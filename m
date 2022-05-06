Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB3E51DF0C
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 20:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391788AbiEFSZx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 14:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346024AbiEFSZw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 14:25:52 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064C068FB3
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 11:22:06 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g3so6737467pgg.3
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 11:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=1Bn6Fj0TZ3zGdE4UsPeAIY1KIpMO6I3COOb6LVgm5QM=;
        b=k1mPzfH8bNMMBToxDKvurgphXSGrDcJjmoP7k2lH3ZL1n7AEcjQtChmQQNsTFpv/Ub
         27bb5/4uvjqUEhel5uJOHOGGV3ybtQQutaheYUQ2O0vbFG7SFAnWTUPIdy3vLlrpGWOy
         PMpzjdVloEDB0WqV+Ubp4r0O/xsPdZkZXxrVnHeBxbyExNR/dZaXwZRQDqdYLPMdwphG
         0HwuI0+My5YnhRHlclWjhT2J3osLnRmlAZ4M0ukVVvfia3XvRKyxn2WPZuwsUM1Rnbk3
         SLR/rSeCVgcbudtssulz+gjOVU1PYSrSUFrLYC2PeGssRbDOyPYIl1+e/US4EwXl90T8
         RbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=1Bn6Fj0TZ3zGdE4UsPeAIY1KIpMO6I3COOb6LVgm5QM=;
        b=KLgUNCNYLFLhnc1+1HJAT36lcbL17iG+bZqMQ9OjP0zVAtNBXwSVWAyNwVCbjCcr+u
         N7ETCf+vtVn2y49mqx2M+k88tCDkTOs5LQ9E6OZIZGPcbUzMANVmY6fXkBMKlwvE8PD0
         TB9bht97HmHSLchw6GI7mPcoC0RX3bBeb9vQoOz8ySt79DlgdjMfKOQYshYxH4wdyog0
         u6BFMZoL/oceTYESD2XzEBsDXU3MnCj/KyIbgsMqm8FhatPZGBDJ9yMHllDAh04hqf0o
         UA1MGJ66ajWEuyrc847Tvn0R28/6fxZDRorWnlDioELDvd6Pt+jcNb7/dynpVHLADo3a
         rZIA==
X-Gm-Message-State: AOAM533M/YE8CY1afeYmQOncTyWVLSP4B96tw3Q4zvgvPa1fe5XGHr9s
        NxXUjq44PpDSpe4UzfSaTD4F6A==
X-Google-Smtp-Source: ABdhPJxNuWDQCcDn422nk7Ac5VbSjn/9TFQs3vXE0ndMEe/9s/U+8P3RxatnzrpBV925WgRr8xissA==
X-Received: by 2002:a63:2a4a:0:b0:3c1:5f7e:beb3 with SMTP id q71-20020a632a4a000000b003c15f7ebeb3mr3690362pgq.441.1651861324894;
        Fri, 06 May 2022 11:22:04 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h19-20020a170902eed300b0015eaa9797e8sm2071976plb.172.2022.05.06.11.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 11:22:04 -0700 (PDT)
Message-ID: <4fc454ca-8b3a-28f6-2246-3ffb998f9f11@kernel.dk>
Date:   Fri, 6 May 2022 12:22:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Guo Xuenan <guoxuenan@huawei.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
 <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
 <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
 <6c417ba7-d677-5076-5ce3-d3e174eb8899@kernel.dk>
In-Reply-To: <6c417ba7-d677-5076-5ce3-d3e174eb8899@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 10:15 AM, Jens Axboe wrote:
> On 5/6/22 9:57 AM, Pavel Begunkov wrote:
>> On 5/6/22 03:16, Jens Axboe wrote:
>>> On 5/5/22 8:11 AM, Guo Xuenan wrote:
>>>> Hi, Pavel & Jens
>>>>
>>>> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
>>>> it is not enough only apply [2] to stable-5.10.
>>>> Io_uring is very valuable and active module of linux kernel.
>>>> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
>>>> found my understanding of io_uring is not enough to resolve all conflicts.
>>>>
>>>> Since 5.10 is an important stable branch of linux, we would appreciate
>>>> your help in solving this problem.
>>>
>>> Yes, this really needs to get buttoned up for 5.10. I seem to recall
>>> there was a reproducer for this that was somewhat saner than the
>>> syzbot one (which doesn't do anything for me). Pavel, do you have one?
>>
>> No, it was the only repro and was triggering the problem
>> just fine back then
> 
> I modified it a bit and I can now trigger it.

Pavel, why don't we just keep it really simple and just always save the
iter state in read/write, and use the restore instead of the revert?

Then it's just a trivial backport of ff6165b2d7f6 and the trivial
io_uring patch after that.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab9290ab4cae..138f204db72a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3429,6 +3429,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
+	struct iov_iter_state iter_state;
 	ssize_t io_size, ret, ret2;
 	bool no_async;
 
@@ -3458,6 +3459,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(ret))
 		goto out_free;
 
+	iov_iter_save_state(iter, &iter_state);
 	ret = io_iter_do_read(req, iter);
 
 	if (!ret) {
@@ -3473,7 +3475,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		if (req->file->f_flags & O_NONBLOCK)
 			goto done;
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		iov_iter_restore(iter, &iter_state);
 		ret = 0;
 		goto copy_iov;
 	} else if (ret < 0) {
@@ -3557,6 +3559,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
+	struct iov_iter_state iter_state;
 	ssize_t ret, ret2, io_size;
 
 	if (rw)
@@ -3574,6 +3577,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	else
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
+	iov_iter_save_state(iter, &iter_state);
+
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
 		goto copy_iov;
@@ -3626,7 +3631,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		iov_iter_restore(iter, &iter_state);
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)
 			return -EAGAIN;
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 27ff8eb786dc..cedb68e49e4f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -26,6 +26,12 @@ enum iter_type {
 	ITER_DISCARD = 64,
 };
 
+struct iov_iter_state {
+	size_t iov_offset;
+	size_t count;
+	unsigned long nr_segs;
+};
+
 struct iov_iter {
 	/*
 	 * Bit 0 is the read/write bit, set if we're writing.
@@ -55,6 +61,14 @@ static inline enum iter_type iov_iter_type(const struct iov_iter *i)
 	return i->type & ~(READ | WRITE);
 }
 
+static inline void iov_iter_save_state(struct iov_iter *iter,
+				       struct iov_iter_state *state)
+{
+	state->iov_offset = iter->iov_offset;
+	state->count = iter->count;
+	state->nr_segs = iter->nr_segs;
+}
+
 static inline bool iter_is_iovec(const struct iov_iter *i)
 {
 	return iov_iter_type(i) == ITER_IOVEC;
@@ -226,6 +240,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1b0a349fbcd9..00a66229d182 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1857,3 +1857,39 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 	return err;
 }
 EXPORT_SYMBOL(iov_iter_for_each_range);
+
+/**
+ * iov_iter_restore() - Restore a &struct iov_iter to the same state as when
+ *     iov_iter_save_state() was called.
+ *
+ * @i: &struct iov_iter to restore
+ * @state: state to restore from
+ *
+ * Used after iov_iter_save_state() to bring restore @i, if operations may
+ * have advanced it.
+ *
+ * Note: only works on ITER_IOVEC, ITER_BVEC, and ITER_KVEC
+ */
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
+{
+	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
+			 !iov_iter_is_kvec(i))
+		return;
+	i->iov_offset = state->iov_offset;
+	i->count = state->count;
+	/*
+	 * For the *vec iters, nr_segs + iov is constant - if we increment
+	 * the vec, then we also decrement the nr_segs count. Hence we don't
+	 * need to track both of these, just one is enough and we can deduct
+	 * the other from that. ITER_KVEC and ITER_IOVEC are the same struct
+	 * size, so we can just increment the iov pointer as they are unionzed.
+	 * ITER_BVEC _may_ be the same size on some archs, but on others it is
+	 * not. Be safe and handle it separately.
+	 */
+	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
+	if (iov_iter_is_bvec(i))
+		i->bvec -= state->nr_segs - i->nr_segs;
+	else
+		i->iov -= state->nr_segs - i->nr_segs;
+	i->nr_segs = state->nr_segs;
+}

-- 
Jens Axboe

