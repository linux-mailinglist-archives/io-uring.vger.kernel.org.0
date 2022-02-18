Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536D84BBE50
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 18:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiBRRZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 12:25:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiBRRZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 12:25:29 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AA52B6202
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 09:25:07 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id c14so4624426ioa.12
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 09:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=u6KsfRbr1TdJDuz3FdnbfKYF29bRCHJ6u+6Apg0EJlA=;
        b=g71hJIzIMYMyTeeJKxu1TrDQdLX12wVI5OnNt9ZZuoMh9T6l0quxbQU+Xm0I1lHIAT
         TMsWjHBRsrL723Q+YFCFUf1OC+D+a68e+GDIkRZrGJIMQI4AOS/jYlhdvFdmV8/lAKIQ
         8EvArWH+BCD2fnlPNZeWcuvOTc1AQJb1GStdUkJ3NEqnwMnq71IVGKp6K5PE/FbnUGQy
         AcqwYB88hgWP91WXlL9PncSSVn4QRevp73ha/f0tse+7yulI5a0vq9rMH1C5gWPr0ADX
         JKmKwQtnDZgP8PBwbHvPLCietr8GhqxwLglcD/dKzMfGdC9iUjmFiozwUn7MDRZ8aSO3
         Nluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u6KsfRbr1TdJDuz3FdnbfKYF29bRCHJ6u+6Apg0EJlA=;
        b=joUkgM1aDmDpz/qiT88GhBh5mYmcxrXQM/P00gM9BZ+JRb3HcdnQMLonAkVgbUlzQY
         Hc2rhrHvwGpf7hDyw1auQh6jBDwxNVvMLY3mdobcmRTRxr5H7fu/ZSegiucWHd7zN5QX
         cMTldUiM1rVr4q+AqvoiAQcBQGBZfI1vuQ/ggBk+0wYZT3v0tyiPc1us7tNLn3vouPmU
         aA7KaSIlAd+yQEXm0GcHGJ+QxH4sfeHhuTPXq5oeV0uJmUnUwAfMdNM/u0ar04BEOSYz
         0AGlvPhrN0KTmyISMfVWMxHuaLBDzONsIJ8UMlMSwbsSEoEKEVNAsTgW69dLGdUEiVHf
         3GjQ==
X-Gm-Message-State: AOAM532DMErqaB/0iDYj/Q/DtL/3huC2/MbRqdiCBOPaBPhYWkyagzLV
        3e0kQnTk1HgfADzzFARedV+R/Q==
X-Google-Smtp-Source: ABdhPJwQNcImmRdySl6RXhleu9LI0SFWhvwcJ0+N1nrBOCmFkfqDewlHFZVhqCf8iaCGso5LZY6Q0w==
X-Received: by 2002:a05:6638:ccc:b0:314:9d17:e026 with SMTP id e12-20020a0566380ccc00b003149d17e026mr4645533jak.14.1645205106618;
        Fri, 18 Feb 2022 09:25:06 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p16sm3856853ilm.85.2022.02.18.09.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:25:06 -0800 (PST)
Message-ID: <9a974e76-f437-f075-6598-c1b04ae3cde8@kernel.dk>
Date:   Fri, 18 Feb 2022 10:25:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 0/3] io_uring: consistent behaviour with linked read/write
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20220217155815.2518717-1-dylany@fb.com>
 <264fb420-26eb-bc0f-b80e-539427093a17@kernel.dk>
 <e2285f43a68c42fc1ed53b581304dce090ac29f4.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2285f43a68c42fc1ed53b581304dce090ac29f4.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/22 10:20 AM, Dylan Yudaken wrote:
> On Thu, 2022-02-17 at 12:45 -0700, Jens Axboe wrote:
>> On 2/17/22 8:58 AM, Dylan Yudaken wrote:
>>> Currently submitting multiple read/write for one file with
>>> IOSQE_IO_LINK
>>> and offset = -1 will not behave as if calling read(2)/write(2)
>>> multiple
>>> times. The offset may be pinned to the same value for each
>>> submission (for
>>> example if they are punted to the async worker) and so each
>>> read/write will
>>> have the same offset.
>>>
>>> This patchset fixes this by grabbing the file position at execution
>>> time,
>>> rather than when the job is queued to be run.
>>>
>>> A test for this will be submitted to liburing separately.
>>>
>>> Worth noting that this does not purposefully change the result of
>>> submitting multiple read/write without IOSQE_IO_LINK (for example
>>> as in
>>> [1]). But then I do not know what the correct approach should be
>>> when
>>> submitting multiple r/w without any explicit ordering.
>>>
>>> [1]:
>>> https://lore.kernel.org/io-uring/8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk/
>>
>> I think this series looks great, clean and to the point. My only real
>> question is one you reference here already, which is the fpos locking
>> that we really should get done. Care to respin the referenced patch
>> on
>> top of this series? Would hate to make that part harder...
>>
> 
> Sure, I will try and figure that out and add it to the series.

Just for full public disclosure, the later version of the above patch is
below.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb2a0cb4aaf8..ab8a4002e0eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -726,6 +726,7 @@ enum {
 	REQ_F_FAIL_BIT		= 8,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
+	REQ_F_CUR_POS_SET_BIT,
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
@@ -765,6 +766,8 @@ enum {
 	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	/* request is holding file position lock */
+	REQ_F_CUR_POS_SET	= BIT(REQ_F_CUR_POS_SET_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
 	/* has or had linked timeout */
@@ -2070,6 +2073,8 @@ static __cold void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	WARN_ON_ONCE(req->flags & REQ_F_CUR_POS_SET);
+
 	io_req_put_rsrc(req, ctx);
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
@@ -2715,6 +2720,8 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 		req_set_fail(req);
 		req->result = res;
 	}
+	if (req->flags & REQ_F_CUR_POS && res > 0)
+		req->file->f_pos += res;
 	return false;
 }
 
@@ -2892,12 +2899,15 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
+		/*
+		 * If we end up using the current file position, just set the
+		 * flag and the actual file position will be read in the op
+		 * handler themselves.
+		 */
+		if (!(file->f_mode & FMODE_STREAM))
 			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
+		else
 			kiocb->ki_pos = 0;
-		}
 	}
 	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
@@ -2979,8 +2989,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 			ret += io->bytes_done;
 	}
 
-	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
@@ -3515,6 +3523,37 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static bool io_file_pos_lock(struct io_kiocb *req, bool force_nonblock)
+{
+	struct file *file = req->file;
+
+	if (!(req->flags & REQ_F_CUR_POS))
+		return false;
+	WARN_ON_ONCE(req->flags & REQ_F_CUR_POS_SET);
+	if (file->f_mode & FMODE_ATOMIC_POS && file_count(file) > 1) {
+		if (force_nonblock) {
+			if (!mutex_trylock(&file->f_pos_lock))
+				return true;
+		} else {
+			mutex_lock(&file->f_pos_lock);
+		}
+		req->flags |= REQ_F_CUR_POS_SET;
+	}
+	req->rw.kiocb.ki_pos = file->f_pos;
+	file->f_pos += req->result;
+	return false;
+}
+
+static void io_file_pos_unlock(struct io_kiocb *req, ssize_t adjust)
+{
+	if (!(req->flags & REQ_F_CUR_POS_SET))
+		return;
+	if (adjust > 0)
+		req->file->f_pos -= adjust;
+	req->flags &= ~REQ_F_CUR_POS_SET;
+	__f_unlock_pos(req->file);
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3543,18 +3582,22 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
+			WARN_ON_ONCE(req->flags & REQ_F_CUR_POS_SET);
 			return ret ?: -EAGAIN;
 		}
 		kiocb->ki_flags |= IOCB_NOWAIT;
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret)) {
+		io_file_pos_unlock(req, req->result);
 		kfree(iovec);
 		return ret;
 	}
@@ -3565,10 +3608,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags &= ~REQ_F_REISSUE;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
-			goto done;
+			goto out_unlock;
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
-			goto done;
+			goto out_unlock;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
@@ -3586,8 +3629,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	iov_iter_restore(&s->iter, &s->iter_state);
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
-	if (ret2)
+	if (ret2) {
+		io_file_pos_unlock(req, ret);
 		return ret2;
+	}
 
 	iovec = NULL;
 	rw = req->async_data;
@@ -3612,6 +3657,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
 			kiocb->ki_flags &= ~IOCB_WAITQ;
+			io_file_pos_unlock(req, req->result - rw->bytes_done);
 			return -EAGAIN;
 		}
 
@@ -3622,19 +3668,26 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * here, and if we do, then just retry at the new offset.
 		 */
 		ret = io_iter_do_read(req, &s->iter);
-		if (ret == -EIOCBQUEUED)
+		if (ret == -EIOCBQUEUED) {
+			io_file_pos_unlock(req, ret);
 			return 0;
+		}
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
 		iov_iter_restore(&s->iter, &s->iter_state);
 	} while (ret > 0);
+	io_file_pos_unlock(req, req->result - rw->bytes_done);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
+	io_file_pos_unlock(req, 0);
 	return 0;
+out_unlock:
+	io_file_pos_unlock(req, ret);
+	goto done;
 }
 
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -3668,7 +3721,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true)))
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
@@ -3680,6 +3734,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);


-- 
Jens Axboe

