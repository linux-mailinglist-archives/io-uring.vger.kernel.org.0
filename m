Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF3391789
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhEZMk0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 08:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbhEZMkS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 08:40:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3285C06175F;
        Wed, 26 May 2021 05:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=u+cVihHkOw2JYBmrSa3iVTOrMPHerSfjBr9BH2LrFDM=; b=Zhzfs4zHx5cRDHdq97XN3X0WZt
        7Dd/A3SoKuHRiA0MXS7P1sBDpy5Y62/aaNdbVfMUqRMHWwhEa7HCR2/VXbafx2pNPZNNzYDx2OAKX
        yntlHubAD4QUD5aC7eYtWE37N7jm/zrgt3qPP/00RpWQhi06QbknfP7QaVYL7QGRuvky9/gAPjZYZ
        RD1tq+OdjBuKI9xAr/8hKRl+iougRaI19Te9P4ZBtBwje7nXw2EW0wwTVjx+f/aYdvJXZTnkqoC3L
        W547euwLjo9zQ/ol9D/P+mvahXMlXAIzHtMqteZuk4bKCZtcXukYhktODCVTgQRxYozWazKfv9RDb
        qlMIOkGNx2bcMMD716VMgCnvb9DSpBtuVVK3nmQnDHwQe/wy7JtUUyCqFSBCOqAZS7mFwX6vF/7Yi
        jrP6P2MbjxTVV6cNYhO/ZLhR0BVP7QJz7605WcPS6FAwhYBpBz7jLgpwkRgC2nfuLcIMa1Tj/W7G4
        NtHu8lQ5sgML918RHGSddlyQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llso3-0007Xc-BL; Wed, 26 May 2021 12:38:39 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
 <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
Message-ID: <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
Date:   Wed, 26 May 2021 14:38:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

>> @@ -333,13 +333,14 @@ TRACE_EVENT(io_uring_complete,
>>   */
>>  TRACE_EVENT(io_uring_submit_sqe,
>>  
>> -	TP_PROTO(void *ctx, u8 opcode, u64 user_data, bool force_nonblock,
>> -		 bool sq_thread),
>> +	TP_PROTO(void *ctx, void *req, u8 opcode, u64 user_data,
>> +		 bool force_nonblock, bool sq_thread),
>>  
>> -	TP_ARGS(ctx, opcode, user_data, force_nonblock, sq_thread),
>> +	TP_ARGS(ctx, req, opcode, user_data, force_nonblock, sq_thread),
>>  
>>  	TP_STRUCT__entry (
>>  		__field(  void *,	ctx		)
>> +		__field(  void *,	req		)
>>  		__field(  u8,		opcode		)
>>  		__field(  u64,		user_data	)
>>  		__field(  bool,		force_nonblock	)
>> @@ -348,26 +349,42 @@ TRACE_EVENT(io_uring_submit_sqe,
>>  
>>  	TP_fast_assign(
>>  		__entry->ctx		= ctx;
>> +		__entry->req		= req;
>>  		__entry->opcode		= opcode;
>>  		__entry->user_data	= user_data;
>>  		__entry->force_nonblock	= force_nonblock;
>>  		__entry->sq_thread	= sq_thread;
>>  	),
>>  
>> -	TP_printk("ring %p, op %d, data 0x%llx, non block %d, sq_thread %d",
>> -			  __entry->ctx, __entry->opcode,
>> -			  (unsigned long long) __entry->user_data,
>> -			  __entry->force_nonblock, __entry->sq_thread)
>> +	TP_printk("ring %p, req %p, op %d, data 0x%llx, non block %d, "
>> +		  "sq_thread %d",  __entry->ctx, __entry->req,
>> +		  __entry->opcode, (unsigned long long)__entry->user_data,
>> +		  __entry->force_nonblock, __entry->sq_thread)
>>  );

If that gets changed, could be also include the personality id and flags here,
and maybe also translated the opcode and flags to human readable strings?

metze
