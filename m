Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390464D3F0B
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 02:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiCJB5A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 20:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiCJB47 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 20:56:59 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48738128592
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 17:55:59 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q29so2495078pgn.7
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 17:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=+S7yhBwRgIbXdFLXp72+HS3pa2K38iKseSnFLdeoVog=;
        b=L/tKcafGZHMY8z/8x+qMd5WRf2He8zKoq7JStHjfdnmFDxPIV+fozYtJZF2nZtuX57
         TUwTCc7SGNBRNbi/3TyyFLqVZvNzAVCXjMQKZq5Z4b1cpzH/CYalIlATSdL0xS2XxDYg
         uAi5VFkBxgKGlVBZIvVDf8/vEIOdHzWYuvsi6LRtFXIuqqpY7DVtIHtEA5ScLIqePvP7
         H+kTmlQvYDdRBjw42m0D240IlP6KBJe37XG0W020qK4JIuN5CjSFEbceXLkaZVV/ZGZj
         plumOcrVVp/gyhEGEg/ve5jOEef3ncv2FaA8rIEwKod0Q76YhXGOtgMyyVL4QNsaB2oP
         bI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=+S7yhBwRgIbXdFLXp72+HS3pa2K38iKseSnFLdeoVog=;
        b=JOGrDXPLliID3W8ExPT1MplDm79QgqZjP12P4Nz5sFMWvNKGZMZqnVVB7RR+4yzBU0
         F4W0smuf+L4K3HQ0MlMOiWJZaXijC7pz2BoctKI1cMwB7dNbAtpyNXgnC5p9DlhwDDSx
         AOTncMzpV0IqntKmqgyHCvvSqYambz1nfW7twti33MBsV4zvhFhEWG7Cp/5C15Og0rR0
         p+L3QsZN4qC1d3cGFgGJdGVcerMBWUesuO4ytByqs5r1BGoUsfLyHhapv8zpoEaNBgvk
         NlhvHhIc51gRsmUyaqoOkkAWpCCrSx8nqnqEc/m6zO6XECp680q0za2Si5lEBDI6LHrN
         CuBA==
X-Gm-Message-State: AOAM5333WpGMJXh/H7s3kd5vOeGpsu4P+iNTYf3fgHLwZyoD4H7Vx2cf
        oSatlPOAmoUItDSdAvQyOj65NmAiXXPm9kha
X-Google-Smtp-Source: ABdhPJydrOtuH78JUzMd97lY81HRwnDoU5C+UxCf4cfmvUUAso4svSvelhG97h6eld8zKAAN/4dXRA==
X-Received: by 2002:a62:a50b:0:b0:4f7:4457:a48a with SMTP id v11-20020a62a50b000000b004f74457a48amr2639051pfm.50.1646877358643;
        Wed, 09 Mar 2022 17:55:58 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4634397pfi.93.2022.03.09.17.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 17:55:58 -0800 (PST)
Message-ID: <f4db0d4c-0ea3-3efa-7e28-bc727b7bc05a@kernel.dk>
Date:   Wed, 9 Mar 2022 18:55:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
In-Reply-To: <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
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

On 3/9/22 6:36 PM, Jens Axboe wrote:
> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>> Greetings!
>>
>> A common approach for multi-threaded servers is to have a number of
>> threads equal to a number of cores and launch a separate ring in each
>> one. AFAIK currently if we want to send an event to a different ring,
>> we have to write-lock this ring, create SQE, and update the index
>> ring. Alternatively, we could use some kind of user-space message
>> passing.
>>
>> Such approaches are somewhat inefficient and I think it can be solved
>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>> ring to which CQE must be sent by kernel. It can be done by
>> introducing an IOSQE_ flag and using one of currently unused padding
>> u64s.
>>
>> Such feature could be useful for load balancing and message passing
>> between threads which would ride on top of io-uring, i.e. you could
>> send NOP with user_data pointing to a message payload.
> 
> So what you want is a NOP with 'fd' set to the fd of another ring, and
> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
> flags for that, we just need a NOP that supports that. I see a few ways
> of going about that:
> 
> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>    io_uring instance. It can then grab the completion lock on that ring
>    and post an empty CQE.
> 
> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>    'fd' is another ring. Posting CQE same as above.
> 
> 3) We add a specific opcode for this. Basically the same as #2, but
>    maybe with a more descriptive name than NOP.
> 
> Might make sense to pair that with a CQE flag or something like that, as
> there's no specific user_data that could be used as it doesn't match an
> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
> Would be applicable to all the above cases.
> 
> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
> that sqe->fd point to a ring (could even be the ring itself, doesn't
> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.

Something like the below, totally untested. The request will complete on
the original ring with either 0, for success, or -EOVERFLOW if the
target ring was already in an overflow state. If the fd specified isn't
an io_uring context, then the request will complete with -EBADFD.

If you have any way of testing this, please do. I'll write a basic
functionality test for it as well, but not until tomorrow.

Maybe we want to include in cqe->res who the waker was? We can stuff the
pid/tid in there, for example.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..b21f85a48224 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1105,6 +1105,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_WAKEUP_RING] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4235,6 +4238,44 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_wakeup_ring_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index || sqe->off ||
+		     sqe->len || sqe->rw_flags || sqe->splice_fd_in ||
+		     sqe->buf_index || sqe->personality))
+		return -EINVAL;
+
+	if (req->file->f_op != &io_uring_fops)
+		return -EBADFD;
+
+	return 0;
+}
+
+static int io_wakeup_ring(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cqe *cqe;
+	struct io_ring_ctx *ctx;
+	int ret = 0;
+
+	ctx = req->file->private_data;
+	spin_lock(&ctx->completion_lock);
+	cqe = io_get_cqe(ctx);
+	if (cqe) {
+		WRITE_ONCE(cqe->user_data, 0);
+		WRITE_ONCE(cqe->res, 0);
+		WRITE_ONCE(cqe->flags, IORING_CQE_F_WAKEUP);
+	} else {
+		ret = -EOVERFLOW;
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6568,6 +6609,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_WAKEUP_RING:
+		return io_wakeup_ring_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6851,6 +6894,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_WAKEUP_RING:
+		ret = io_wakeup_ring(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..088232133594 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_WAKEUP_RING,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -199,9 +200,11 @@ struct io_uring_cqe {
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
+ * IORING_CQE_F_WAKEUP	Wakeup request CQE, no link to an SQE
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
+#define IORING_CQE_F_WAKEUP		(1U << 2)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,

-- 
Jens Axboe

