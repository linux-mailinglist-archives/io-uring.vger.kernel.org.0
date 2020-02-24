Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D2E16B41B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBXWef (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 17:34:35 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:38036 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWef (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 17:34:35 -0500
Received: by mail-io1-f65.google.com with SMTP id s24so12016656iog.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 14:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LcEDW2DJjfwsN2jHoNapXxaO0EbP3e6SpLIeDbSLDHo=;
        b=j1rlVEQ53oIIDmRKRyf+Ub8PZorvJ3Jvn72rJSDxjgIO81vPRNoI59soGQPuKNZJp2
         i/5WLDmIgf0v/yr1ZYQU4AwcC9S7zFI3pB09ahCFOj1Et38mME2/1bwjNNNudOfslkER
         Y7pj9ORfxZLBq5mobTaCO8WL7x6iOviyDcSWOrE8v0t55bA45x6KIX2Sdt6o5dj3ObsQ
         qemAolW2soW4xHKVidIZqz+sPE1dmWwmn4tUmuy6RzDzKwMWmrd0/vu8GXjcjf2u2QUV
         Ibo9VXcvhctVApMiEBM678gnsV7kLb1BpI9t4zqq9vgcemKDvrJXsrG3IQ2v/uu8saMy
         MTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LcEDW2DJjfwsN2jHoNapXxaO0EbP3e6SpLIeDbSLDHo=;
        b=FS7VICNQ9FVwkPXm6CRAy/uTts1WUv+h8tuJCkWcfjtb6nPWRucRBZ8zdjbwfSWVyo
         tNVzQDH7av6X/3jsyR9RokWpN0wx9+rOP2PCv15wLRNvhQgD84wj7dvF/KWmrZFOTm6p
         kr9GE4RQvmXICcznh/SYHpT6wH1He0D0HvZUjKtWD0N6nArb3F1f3k7SrLyZCs2fxcuQ
         hwRt7Mbc5jQryMC/Qj5j6Pl/dZrcIW8FlYv7O5SVuMGB33WUV63F33d5yI1dm/QpkahC
         QlNM7Obuhm9QBOllWmeKpywa5TOXi4NOeHxxz27f7uHyJlWebVAVIykKdsMANIK6+2Fv
         DTVw==
X-Gm-Message-State: APjAAAWIoBUwkD+8llouV/4eMEq9WdTuUWd32KE3BAS41PH2HoqpiodI
        lmDAafPb0ulH3Rnd2iga8IoC7Q==
X-Google-Smtp-Source: APXvYqwruaA7++v/6de+pBK64t/i++bMn+3fXg2Pg3U7puKprnod7XwhrZ5mlI7mLXHnnWdFC3VRgQ==
X-Received: by 2002:a02:390a:: with SMTP id l10mr53494289jaa.42.1582583674519;
        Mon, 24 Feb 2020 14:34:34 -0800 (PST)
Received: from [192.168.1.147] (174-23-131-244.slkc.qwest.net. [174.23.131.244])
        by smtp.gmail.com with ESMTPSA id 69sm4745386ilc.80.2020.02.24.14.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 14:34:34 -0800 (PST)
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1582530525.git.asml.silence@gmail.com>
 <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
Message-ID: <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
Date:   Mon, 24 Feb 2020 15:34:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:35 AM, Jens Axboe wrote:
> On 2/24/20 1:32 AM, Pavel Begunkov wrote:
>> *on top of for-5.6 + async patches*
>>
>> Not the fastets implementation, but I'd need to stir up/duplicate
>> splice.c bits to do it more efficiently.
>>
>> note: rebase on top of the recent inflight patchset.
> 
> Let's get this queued up, looks good to go to me. Do you have a few
> liburing test cases we can add for this?

Seems to me like we have an address space issue for the off_in and
off_out parameters. Why aren't we passing in pointers to these
and making them work like regular splice?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 792ef01a521c..b0cfd68be8c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -448,8 +448,8 @@ struct io_epoll {
 struct io_splice {
 	struct file			*file_out;
 	struct file			*file_in;
-	loff_t				off_out;
-	loff_t				off_in;
+	loff_t __user			*off_out;
+	loff_t __user			*off_in;
 	u64				len;
 	unsigned int			flags;
 };
@@ -2578,8 +2578,8 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	sp->file_in = NULL;
-	sp->off_in = READ_ONCE(sqe->splice_off_in);
-	sp->off_out = READ_ONCE(sqe->off);
+	sp->off_in = u64_to_user_ptr(READ_ONCE(sqe->splice_off_in));
+	sp->off_out = u64_to_user_ptr(READ_ONCE(sqe->off));
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
 
@@ -2614,7 +2614,6 @@ static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
-	loff_t *poff_in, *poff_out;
 	long ret;
 
 	if (force_nonblock) {
@@ -2623,9 +2622,7 @@ static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
 		flags |= SPLICE_F_NONBLOCK;
 	}
 
-	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
-	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
-	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+	ret = do_splice(in, sp->off_in, out, sp->off_out, sp->len, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
 
-- 
Jens Axboe

