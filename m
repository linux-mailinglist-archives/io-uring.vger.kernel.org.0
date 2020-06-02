Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EAF1EC46C
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 23:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgFBVjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 17:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgFBVjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 17:39:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13AAC08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 14:39:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bh7so1930133plb.11
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 14:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n4+b/AQdmASZcNal8efku2r7p4KfSG0652SOwFRCpfQ=;
        b=wz/i4NXZgNCrpu9TPYSjNZBzHKL+oyDQ+uZv4k2x70lnyU8GVbLOjc5GJR8zp+3e/j
         gr46sx1eu5Wxkme82YL5Ebz83SjofK3gQbfB6ZZcvSxvHypuBZZuTuizjax2rabzMtPL
         JntNEdAGbzulU8mhI0yDkx+I+t6s35r08UQUf/OPkZtX7g0hQQnjcoQsxzkDqVWcNjxT
         ed5bQwRfc3DyxBoVOtK7w9DVE8Odt412sFCb6oPNktFJyU+9GlJoqy1n5IMP3qhVKS/q
         wiupoQ5cth5w5JetGQm9YjEUju+STwHPBwT90u2cvfLZhzsjdB9EpfjON6KKp3tBHyRn
         kRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n4+b/AQdmASZcNal8efku2r7p4KfSG0652SOwFRCpfQ=;
        b=ajI09t96weXyCTd3N57SOhlPcuSUxlVANopkPzy5QaHpHITEd0vCe6tioG7J2owpZc
         39gCBa7rS6GHp4cyjQRA89fZSH16pf+vBut/MxLvdtI1KEtD5He+sdkAxUMDEjnEdBlS
         3yHimlPUDsKlO0yonwS6Sl29HHscxl3DIYgmkglk7MPBGKILhFrRLhL/VHOIbO9O3ww1
         glW2oocMaqw7G9/FhEU3io5B5rTRLyG550K6PzrLbfWy1FAeAJqUGBRkE+bTZozGfEM5
         9jR/QU3Qmq5cDv0mnPX8gTy0yTX9Twtvf5dOFikh8SWsOt/lw+iiWJLSMAtp8pWdITaE
         amWA==
X-Gm-Message-State: AOAM532L8FOwVyB+tx3sXnK+1hWr+lySHqzknkOaEN9TEi/Xe/llzmUE
        Ovf8skvAYZPqtD4YFtVvcvAIJDCPdqSakw==
X-Google-Smtp-Source: ABdhPJxW/fGXvQa4zUxClyfE80hs0aWRu3hruOagEcNowlGFC2ZYs/JXjjHUxMZJYzeJdeIJBht/PA==
X-Received: by 2002:a17:902:c213:: with SMTP id 19mr26800734pll.190.1591133955658;
        Tue, 02 Jun 2020 14:39:15 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q29sm84210pfg.79.2020.06.02.14.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 14:39:15 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Jann Horn <jannh@google.com>
Cc:     Clay Harris <bugs@claycon.org>, io-uring <io-uring@vger.kernel.org>
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
 <CAG48ez1CvEpjNTfOJWBRmR6SVkQjLVeSi2gFvuceR0ubF_HJCQ@mail.gmail.com>
 <9c140709-f51f-af35-86c3-68fd02fffb18@kernel.dk>
 <CAG48ez3x+d1acZEQv_rouXeMq3+qWsGpntXum=iv6FMZ9ch6Jw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc265ddc-8fa1-81ec-0ef6-4b6df29c7747@kernel.dk>
Date:   Tue, 2 Jun 2020 15:39:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3x+d1acZEQv_rouXeMq3+qWsGpntXum=iv6FMZ9ch6Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/20 1:16 PM, Jann Horn wrote:
> On Tue, Jun 2, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 6/2/20 12:22 PM, Jann Horn wrote:
>>> On Sun, May 31, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> We just need this ported to stable once it goes into 5.8-rc:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.8/io_uring&id=904fbcb115c85090484dfdffaf7f461d96fe8e53
>>>
>>> How does that work? Who guarantees that the close operation can't drop
>>> the refcount of the uring instance to zero before reaching the fdput()
>>> in io_uring_enter?
>>
>> Because io_uring_enter() holds a reference to it as well?
> 
> Which reference do you mean? fdget() doesn't take a reference if the
> calling process is single-threaded, you'd have to use fget() for that.

I meant the ctx->refs, but that's not enough for the file, good point.
I'll apply the below on top - that should fix the issue with O_PATH
still, while retaining our logic not to allow ring closure. I think we
could make ring closure work, but I don't want to use fget() if I can
avoid it. And it really doesn't seem worth it to go through the trouble
of adding any extra code to allow ring closure.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 732ec73ec3c0..2ce972d9a49e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -696,6 +696,8 @@ struct io_op_def {
 	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
+	/* don't fail if file grab fails */
+	unsigned		needs_file_no_error : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -802,6 +804,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
+		.needs_file		= 1,
+		.needs_file_no_error	= 1,
 		.file_table		= 1,
 	},
 	[IORING_OP_FILES_UPDATE] = {
@@ -3424,6 +3428,10 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
+	if ((req->file && req->file->f_op == &io_uring_fops) ||
+	    req->close.fd == req->ctx->ring_fd)
+		return -EBADF;
+
 	return 0;
 }
 
@@ -5437,19 +5445,20 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
-		if (!file)
-			return -EBADF;
-		req->fixed_file_refs = ctx->file_data->cur_refs;
-		percpu_ref_get(req->fixed_file_refs);
+		if (file) {
+			req->fixed_file_refs = ctx->file_data->cur_refs;
+			percpu_ref_get(req->fixed_file_refs);
+		}
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
-		if (unlikely(!file))
-			return -EBADF;
 	}
 
-	*out_file = file;
-	return 0;
+	if (file || io_op_defs[req->opcode].needs_file_no_error) {
+		*out_file = file;
+		return 0;
+	}
+	return -EBADF;
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,

-- 
Jens Axboe

