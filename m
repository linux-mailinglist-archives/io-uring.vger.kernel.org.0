Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 164AB1606E8
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 23:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgBPWXP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 17:23:15 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37361 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPWXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 17:23:15 -0500
Received: by mail-pj1-f68.google.com with SMTP id m13so6331242pjb.2
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 14:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dsMZbC5u0cNEe+uf+u+YMRXbQjiqsYmPgVmh+HSiZ7A=;
        b=fKflyMklpPzg9ICsipQ55P6eblFXz2NIUZe1cSip4IT+UIPaVuYUfN5craQkH78/Cm
         07gl8SsYoCYexCZSAmZhS91GCe4R4UsThzrQvy1UNPT/mB8lg9goQ33cb5IVBlyGO++X
         xJqL0a3d6NUePJDB9MtdTuax9hQE3mQw60G50x4vnOhZ2jdiH7NSoDzDjNmKuqc66lNa
         nWLmJCRKzdRVCnnEcHKhRdrcZ3ftf373a+fPLMNZNOxyJiCQ1PLa1enMCBTLuypzZkVi
         Z9qVcI27YUdmXXnL6ahhgPZMz5La2w4r54XOrPyzm0S3fAPxI8Z/+Nz+QbOl3l1rQU2D
         VCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dsMZbC5u0cNEe+uf+u+YMRXbQjiqsYmPgVmh+HSiZ7A=;
        b=psyC5ILQgjW3JmWiMYv1BE0EsX9MOqSGJPA7ZDRhJWSPpVmRkZ0KQ/5PUUwMB1vi6s
         FeSIn17xKAeN/Yjy569xohXhgSVC8T9Y2bMowK8eDgDu6WT8W28N+arlP+ArGn5Zc3jU
         tUcK4pIqVu44Pdfqb/Eq9aRRtCYVeYPNgFAYsYFThmUNW7BQ2n7e+KvAnI2b/pluSCpZ
         ospPIsRDXa9CnM7c9OT9FljANFg6zxfI2M+KAssFu3tyjrY1Do1Tmgdwf0vMqcJUzw+5
         72QyJDmoAKI2XOTDEPm85MB1DnnigWq+1u9Fw9V/r2UJn4q+lu5B2wQ9cDEsy48I/irV
         GaiA==
X-Gm-Message-State: APjAAAWfjycfeqJWMuQkgXJnpnqHathaCKRcKAW9EcuF7HHSOaaKVhgu
        4HQ+XW0GS3JeCIysQs5weVDfun5dXao=
X-Google-Smtp-Source: APXvYqxTD1tEKwuOQ22d7Uiv0YkEUjNDjWseE4SznQwGUOXIox+cjFIjVDDWbLImaLPTlHzvnuosQQ==
X-Received: by 2002:a17:902:fe8d:: with SMTP id x13mr13763629plm.232.1581891794188;
        Sun, 16 Feb 2020 14:23:14 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:f9ca:4e53:3b3b:ca45? ([2605:e000:100e:8c61:f9ca:4e53:3b3b:ca45])
        by smtp.gmail.com with ESMTPSA id d2sm14123889pjv.18.2020.02.16.14.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 14:23:13 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
 <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08cc6880-be41-9ca7-3026-7988ac7d9640@kernel.dk>
Date:   Sun, 16 Feb 2020 14:23:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/20 12:06 PM, Pavel Begunkov wrote:
> On 15/02/2020 09:01, Jens Axboe wrote:
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index fb94b8bac638..530dcd91fa53 100644
>> @@ -4630,6 +4753,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	 */
>>  	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
>>  	    (req->flags & REQ_F_MUST_PUNT))) {
>> +
>> +		if (io_arm_poll_handler(req, &retry_count)) {
>> +			if (retry_count == 1)
>> +				goto issue;
> 
> Better to sqe=NULL before retrying, so it won't re-read sqe and try to
> init the req twice.

Good point, that should get cleared after issue.

> Also, the second sync-issue may -EAGAIN again, and as I remember,
> read/write/etc will try to copy iovec into req->io. But iovec is
> already in req->io, so it will self memcpy(). Not a good thing.

I'll look into those details, that has indeed reared its head before.

>> +			else if (!retry_count)
>> +				goto done_req;
>> +			INIT_IO_WORK(&req->work, io_wq_submit_work);
> 
> It's not nice to reset it as this:
> - prep() could set some work.flags
> - custom work.func is more performant (adds extra switch)
> - some may rely on specified work.func to be called. e.g. close(), even though
> it doesn't participate in the scheme

It's totally a hack as-is for the "can't do it, go async". I did clean
this up a bit (if you check the git version, it's changed quite a bit),
but it's still a mess in terms of that and ->work vs union ownership.
The commit message also has a note about that.

So more work needed in that area for sure.

-- 
Jens Axboe

