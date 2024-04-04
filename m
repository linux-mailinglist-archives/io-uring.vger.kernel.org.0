Return-Path: <io-uring+bounces-1396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 359B189930E
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 04:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D08288FE3
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 02:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9989FC1D;
	Fri,  5 Apr 2024 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhiJGwBj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6674179C4;
	Fri,  5 Apr 2024 02:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712283464; cv=none; b=sEj4o0T9jQ3Lu8UadfKHn2zU8jDFl67NVIgGRLfX+EP0KNylcXA/jAkcNPipyhD/R1rFEHKizKzwU+Da+52ulYubl9f0UKd63a+hx49zPilRNRLi6sQhi8A5BaLTS45EUNi6t7H2sg00BPek4sZFidcUqa7kie5Td+umAIvjsVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712283464; c=relaxed/simple;
	bh=95Xk9x3INlTNfIL8CNkINyPj5/oz86DuWfwmqEH2ZBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMLYzIMRkhv0WW7nqyCAHlC4obLCZKcNc1p7q6uzdCVhotadM62HIeZ87uzQzcTDLLd0Eg2NNGhAfFtTfPnLRGOPh74025NmFpblPphb5NL0GSy/RHXp1OBdkH0WH2jPudqkO1j+TXVOBJP/DP8J0DIENTWCG6cmVWeQbVEcRYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhiJGwBj; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-78d496add91so13120385a.2;
        Thu, 04 Apr 2024 19:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712283461; x=1712888261; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQIiTD5tCLcRtpuvftDkyv/yaTGrweTC1c2Ho0HIRxc=;
        b=HhiJGwBjLKi/CoLWHc7fpM/Phc3LGgqtWgJ8rclW7+Sy+x1D7A195Ib5ZaPNHMDLwx
         brWzsET8VjQt6lzosrpAONOJzQ0d6FaVznWjsZ2iomgnDb6z+8r7noN1L84y6xNnKgXG
         KmsCJ0c0xa+eajzGofIHdOm+6cbr8ODIhJSpUUdmfW6Jel1Rs8/uB7TZiruRThVgCdRP
         tQMMuPjljCHTsX23kEYyITzvj9eMEL58HAEjY03avN2lNp+2aeIJGZoWNpKxYipSB0FM
         9KdnNmjmVEcbSRB43MLhCrLqDy9huaaQAAf+vsOZmntMSC9vIzVRNNT8r2wv23aVSZWS
         HK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712283461; x=1712888261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQIiTD5tCLcRtpuvftDkyv/yaTGrweTC1c2Ho0HIRxc=;
        b=G8Uz/k1XPosqnmVLsHbfLN3BkqrahAAe8zG3tX+wJ2lc20A+ItL/D4SBqhFq810Gyb
         Uw9IFuvx5Ut6xYL5AK0CCvUZg3MPVEsW2mLHIdWiBLwQ4I4UF4UAO9DWFNVG80koY5kA
         WjEiDoeg1X9QbO/pWCb6a51LadPNvPrDGKqhi3C6oz/kqMc827QC+qu0sxHT+eZKKLgt
         d+r6iR5KMFJiJE/atbSFpXoKQ42otkMuVh+yWCAjQVRKsJxR1EOTH+ildiUDtKpAt+lw
         0nKNr1nDe4h4kb6A7aOj+GYFWcXuHNgOKxbZgqFxpNmx8khA4mdEmwv6jrhu5rtZbEFf
         nS+A==
X-Forwarded-Encrypted: i=1; AJvYcCVUQOUHFhLd44KYAHhjJTu/PCpBMJRmQGn8D0zuUO9XteHkNO2uaCuwr9Id3gVmupMiDzgBxRU+VQ/pi+SMS9JEzqNz+o0awqESsUyGxsSWg/RVFh34P4FZLHGTujlfVDwVfp0IB7v+ZNCmzMIn+UaKnnrLgEydaOxudiZ/fyUNVFV3tvvo
X-Gm-Message-State: AOJu0YykrKCqCsaZMImb4G1shzEnKP41Rm1hmNfZ5QkfwLHsI8aWelzb
	sWf3SrCRX3Q0GuT3szV6c07vEqK/XOgr0p1vNgQRyZFVWOmqO84L
X-Google-Smtp-Source: AGHT+IF3ow1B9J0lbr1hpY+cfkZGU0Oc9xKWN/nUeeSP5PSzEOm/O0vWfinWMNAf1a82ldP7ao1kFw==
X-Received: by 2002:a05:620a:4f3:b0:78b:e190:1f2a with SMTP id b19-20020a05620a04f300b0078be1901f2amr181875qkh.18.1712283461231;
        Thu, 04 Apr 2024 19:17:41 -0700 (PDT)
Received: from localhost ([2601:8c:502:14f0:acdd:1182:de4a:7f88])
        by smtp.gmail.com with ESMTPSA id bk32-20020a05620a1a2000b00789ee7c9d2fsm260333qkb.109.2024.04.04.19.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 19:17:40 -0700 (PDT)
Date: Thu, 4 Apr 2024 18:17:41 -0400
From: Oliver Crumrine <ozlinuxc@gmail.com>
To: axboe@kernel.dk, asml.silence@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, 
	leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring
 zerocopy
Message-ID: <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1712268605.git.ozlinuxc@gmail.com>

In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
specifically disabled REQ_F_CQE_SKIP, as (at least from my
understanding) the userspace program wouldn't receive the
IORING_CQE_F_MORE flag in the result value.

To fix this, instead of keeping track of how many CQEs have been
received, and subtracting notifs from that, programs can keep track of
how many SQEs they have issued, and if a CQE is returned with an error,
they can simply subtract from how many notifs they expect to receive.

Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
---
 io_uring/net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 1e7665ff6ef7..822f49809b68 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1044,9 +1044,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
-	if (req->flags & REQ_F_CQE_SKIP)
-		return -EINVAL;
 
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
@@ -1342,7 +1339,8 @@ void io_sendrecv_fail(struct io_kiocb *req)
 		req->cqe.res = sr->done_io;
 
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
+	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC) &&
+	    !(req->flags & REQ_F_CQE_SKIP))
 		req->cqe.flags |= IORING_CQE_F_MORE;
 }
 
-- 
2.44.0


