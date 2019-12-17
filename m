Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEEF122E52
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 15:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfLQOQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 09:16:47 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40046 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfLQOQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 09:16:47 -0500
Received: by mail-lf1-f65.google.com with SMTP id i23so7068822lfo.7;
        Tue, 17 Dec 2019 06:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xlRkPJ2SEXs8vMsht2fGp1KJqPki3AeywUT3STRcBqE=;
        b=pNerajbJfMbMciD+1btyom7lLX1CPk4VtH9PLBldrb/4MWc+pFhws6C8JRCjwOem3B
         1xmxBvdXdmyxGrAl7ML9tWNAMI3i6omtt7Fb+ksrOs6u9VER5hAJnO0fOl6JDmHDyO2p
         0Ito47Affr4qm7yUNkNbQmbiFwi+al+6aL429a1O773bP6KKve4Sl0qGTf3pvtImL2Od
         3SkxVThHn8nqxPajDFmhylmcfSAbXn+yMU7YBRTw0HmXZomQdduDZpjXsK2o3eHKcO0w
         cywyK95ghbpNCoU/xxz3CF+2QYF1bWunxgZ2B0cbH6zP0wQZcDNL5OYDzLAbnYGFqbfF
         qxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlRkPJ2SEXs8vMsht2fGp1KJqPki3AeywUT3STRcBqE=;
        b=PFTAmBI5Ac7DaTG7en+j5qiMdsRU/15pcN+cHHQAuWAsaAE65PKaycIWoVn2k+PNxR
         iEQR+gBKcxgjxIt4/PNlg+rtASY3ysg3VYB1d9UsDVhLtp3gq4MzLYW1XANgizmeQyBm
         ThYwbrW8vP9B2qSstERgKYM7JhZY49LWT+Y/vXT2MxRDWPbJpEoGe+Gub+URQX+CWUNe
         VW1zXS/tU3PbKfeUSQgxyHalVcTfTtfY3mmWVWr9SBMOu2Drbhiu0CL2CapgfBbVyJ78
         bDO9aZ21C1nJnj6OTXn8l1Q3PwKJOWUH1wzlZyEZo7VEp2116hsnh/tOep9uL8pVJ8pq
         EzBg==
X-Gm-Message-State: APjAAAVCdR+Us3U6+qNZItMUMqtaWFnBVkBBEv2DmI8ozyP/3Wrwdsi5
        iUWCJjSw4s6D1o7nmNaFOYfaVnMVcPo=
X-Google-Smtp-Source: APXvYqzZmO0QaN360MRudjlIAma561Iv+ukGoVeX405aX62AZOqAfm4KOdQWEx2sa3SkZdPmUapC0w==
X-Received: by 2002:a19:7015:: with SMTP id h21mr2839860lfc.68.1576592204973;
        Tue, 17 Dec 2019 06:16:44 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id h10sm1562537ljc.39.2019.12.17.06.16.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 06:16:44 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Dmitry Dolgov <9erthalion6@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <20191217140057.vswyslavkmrbcebz@localhost>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3d59d0ed-50c0-2308-7b6d-c3f5d4459638@gmail.com>
Date:   Tue, 17 Dec 2019 17:16:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191217140057.vswyslavkmrbcebz@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/2019 5:00 PM, Dmitry Dolgov wrote:
>> On Tue, Dec 17, 2019 at 02:22:09AM +0300, Pavel Begunkov wrote:
>>
>> Move io_queue_link_head() to links handling code in io_submit_sqe(),
>> so it wouldn't need extra checks and would have better data locality.
>>
>> ---
>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index bac9e711e38d..a880ed1409cb 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>  			  struct io_kiocb **link)
>>  {
>>  	struct io_ring_ctx *ctx = req->ctx;
>> +	unsigned int sqe_flags;
>>  	int ret;
>>
>> +	sqe_flags = READ_ONCE(req->sqe->flags);
> 
> Just out of curiosity, why READ_ONCE it necessary here? I though, that
> since io_submit_sqes happens within a uring_lock, it's already
> protected. Do I miss something?
> 
SQEs are rw-shared with the userspace, that's it. Probably, there are
more places where proper READ_ONCE() annotations have been lost.

>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>  		}
>>  		trace_io_uring_link(ctx, req, head);
>>  		list_add_tail(&req->link_list, &head->link_list);
>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>> +
>> +		/* last request of a link, enqueue the link */
>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
> 
> Yes, as you mentioned in the previous email, it seems correct that if
> IOSQE_IO_HARDLINK imply IOSQE_IO_LINK, then here we need to check both.
> 
>> +			io_queue_link_head(head);
>> +			*link = NULL;
>> +		}
>> +	} else if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {

-- 
Pavel Begunkov
