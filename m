Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49135362452
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 17:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbhDPPmd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 11:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241651AbhDPPm2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 11:42:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60311C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:42:02 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c15so23483958ilj.1
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3nnck9alDGZ6YDi3422ygJEudVtXdumKp57eWU1TVIY=;
        b=1CYPksrSrdYNoK/UegVUBrGOAfMO6TuCcocC2l1ct1Dpx2GmLjccoi2JrZCyNKKvTo
         K3r0Fv6vqtM3z5Ga6FYPp9kGsxvrCqY2Qscywm6cq1OpA2gynzzAo3jiz1oHcX4FumQB
         RicUH1bNwS5o8tkM+Y5hG9ccSnx5vmx7KZm5K0BQSnkadKrqpIevUs12DOTtt8bUr6SJ
         RTfO8pyXzge3Wk/CMl86LEC920qIw9NWv+GWsOD85+1UH8G4yQeL9yRFqSs2uTYGzPHF
         1fV64rU8jU6ESQa298D2b9kbpDpoZ5nQ90mkcGGs8tzbBCC3H4I0o0q0gkBMvZ5JhBNH
         tK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3nnck9alDGZ6YDi3422ygJEudVtXdumKp57eWU1TVIY=;
        b=SxssRCPIVRZNPC9/UwJOR76k3hhkDjRVgu5thCi0jkEYBdOmUsYU24eepOku5BrFnB
         1UAYXV7MwTvJc9/Vc3L/BWyLjAsq5+mJkNBx6AUbeTbh98Grc2TJ9m63M+5Y8MhVeg7H
         nSIeJSGeQcpYNTXAjpVUN/nEFdnd7Y+KhxQ0NvJ3jrjyE925Weyv8Brj7ePBA+i5uICv
         oWi0NDooiM3YaHWhyrABtndJEHeYrTLadbSmlS3ECk9J6effNpGrZQsuZk/I4QcVSN6O
         AzT7kuQQJBmNt0GQBFpggY+QU0xAdKXcl3TMqGVFXLYr43t7vd0QbNBX//HwSOrg47Xx
         YzIA==
X-Gm-Message-State: AOAM533OJhZSmIXvc1FWGGhKSLMU3u0dtNojWQfDHcYkA/xvk7oV1MpZ
        lPx0eT3wn98AJBcqdCOLmJKBmRjBU2+FWA==
X-Google-Smtp-Source: ABdhPJzixAibeW6JGeACkFvXJtzK6xMlU9owEPl6+iutXZJJA+6t3EprGw69jAa8fh4Vd1oFmKuECw==
X-Received: by 2002:a92:c26a:: with SMTP id h10mr7258269ild.294.1618587721553;
        Fri, 16 Apr 2021 08:42:01 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e6sm2864391ilr.81.2021.04.16.08.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:42:00 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: put flag checking for needing req cleanup
 in one spot
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20210416012523.724073-1-axboe@kernel.dk>
 <20210416012523.724073-3-axboe@kernel.dk>
 <82666c0c-fad4-05b7-5af7-5c3dbe879c8c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b65f80c4-482c-403d-f594-f81433a931ac@kernel.dk>
Date:   Fri, 16 Apr 2021 09:42:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82666c0c-fad4-05b7-5af7-5c3dbe879c8c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/21 7:25 AM, Pavel Begunkov wrote:
> On 16/04/2021 02:25, Jens Axboe wrote:
>> We have this in two spots right now, which is a bit fragile. In
>> preparation for moving REQ_F_POLLED cleanup into the same spot, move
>> the check into io_clean_op() itself so we only have it once.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 19 ++++++++-----------
>>  1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 87ce3dbcd4ca..a668d6a3319c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1601,8 +1601,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
>>  static void io_req_complete_state(struct io_kiocb *req, long res,
>>  				  unsigned int cflags)
>>  {
>> -	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
>> -		io_clean_op(req);
>> +	io_clean_op(req);
>>  	req->result = res;
>>  	req->compl.cflags = cflags;
>>  	req->flags |= REQ_F_COMPLETE_INLINE;
>> @@ -1713,16 +1712,12 @@ static void io_dismantle_req(struct io_kiocb *req)
>>  
>>  	if (!(flags & REQ_F_FIXED_FILE))
>>  		io_put_file(req->file);
>> -	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
>> -		     REQ_F_INFLIGHT)) {
>> -		io_clean_op(req);
>> +	io_clean_op(req);
>> +	if (req->flags & REQ_F_INFLIGHT) {
>> +		struct io_uring_task *tctx = req->task->io_uring;
> 
> Not in particular happy about it.
> 1. adds extra if
> 2. adds extra function call
> 3. extra memory load in that function call.
> 
> Pushes us back in terms of performance. I'd suggest to have
> a helper, which is pretty much optimisable and may be coalesced by a compiler with
> adjacent flag checks.
> 
> static inline bool io_need_cleanup(unsigned flags)
> {
> 	return flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED);
> }
> 
> if (io_need_cleanup(flags) || (flags & INFLIGHT)) {
>     io_clean_op();
>     if (INFLIGHT) {}
> }

Sure, we can do that. Particularly because of needing to rearrange
to get it inlined, but no big deal. I'll fiddle it.

-- 
Jens Axboe

