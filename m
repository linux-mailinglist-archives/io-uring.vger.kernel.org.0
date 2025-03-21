Return-Path: <io-uring+bounces-7170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E01DEA6C2C6
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FB431892631
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24D321859F;
	Fri, 21 Mar 2025 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EtrMiy+E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f98.google.com (mail-oo1-f98.google.com [209.85.161.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A913C914
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 18:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742582950; cv=none; b=YVzVcosgZO8FJB5Nf1wVWYMNp3o5om15VjI0KK+Jfreso8fUZpvVn3E9bUsVl1CrcFD+395sByaqUurKdegiVuoZNyqZdLvF/qQuk+91yviFFRVzPmPx2qnmTVHHeUfrIAIShg7I1G8DqyQOPlqiEnQsm5HrYgo1PDV3SYxR/Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742582950; c=relaxed/simple;
	bh=4ffaNcfXCWGV/yaMUIFe4pBx/L0pwgKtwX1/8+wF6S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAxLgQ3ZCCamCRzmmh1O8Q9ORorPC15LObXgApYPceaNBH5tp/NjR7LAaTN/vADhpP6/aB2uziFBVZ8vbMPQnjLRpe0bLMrOZDwKVJjgAiMp7zXIEQ5e3TQ5fA+BNE1svU7KfUoPAbvk6Lm0X11RNMGqEkkkwo+Vv9M25/HL/FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EtrMiy+E; arc=none smtp.client-ip=209.85.161.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f98.google.com with SMTP id 006d021491bc7-6002337132eso135545eaf.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742582948; x=1743187748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVXOFSIvNRMFYjPBLLvsP0Qii/nfc/7BrZwWwlECW8U=;
        b=EtrMiy+Ec4kqfz+pRrZO/gYdv5U8airFRGYKMSNlyaATf0u8Fy5kfURXOmb1IOuYnr
         uELr6/0Lsnoq38SiwMvpmJcLsLf+3nsoVQxyBVa/+1plQkqg5gujLasKGwvexOQFMKOg
         6N07hS716+KYvr6xTajDPG5WwcA3fi4b+UmScEFVB8xiYdWkVVKECE80tJhZwsjCpZWR
         8VdxMV6gi0oc0tIIGkkeviA3bFDlUVlzo2A3ns+3Jb/L/uC2guP5gtPA7vxf/Dogv6K8
         QYlskyeyMSPefLuPfuxOBd6KbJ5Qi7PC4KwvNm9k1q8CEI55GrTkjwWe7ZzgUGTiFRtO
         +1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742582948; x=1743187748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVXOFSIvNRMFYjPBLLvsP0Qii/nfc/7BrZwWwlECW8U=;
        b=dbt3zwHLmXY94VghOp4SR7N42m7i9qCuI7VCHdz6n8cnCIrJjMfrqXovBsvIfcdtvL
         lgSPNn9w1igpp8LDiYF2izI8lz6UGFfY4K+H5gcQjxn3T+CUrabIVKFh5uahWwO+LZ5h
         R87Uuvz+kYXABG1w9f2nx/x9utahVzqmiSdd05TDRfoevf62l3weppggEyW6qcDkIgAD
         xwhuEGeD6MKETBIS86/XYsrBFUK9qAWYQd6KUO+2XhL/Q230QDArqTuytkAMYn4cTR6Q
         7th88KQ2rohBdsB5O79C84v+WZ2pawk0muyRmwAg18itdzp+F90m62EdNJkQZdD7j7p7
         OKgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHG+7TUGnayS/PVr+Nh1aRc1pVZ2nIZSrYcLwfW5AY6688Sfs/rNQhrDWwgOzO5zckuegcOThGGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBOb+Y2u06Fa5fvMUE9ML2cni1ANBtA7WKa0H+WbbZuA6W1+Xq
	D/OZRYrYRnYlgp4JMNuIOp/+5W9ON1cNCo5mYLZLz8srPnGAJUjScDB3o209nm7dO85SKjGOmnl
	9UAKzRrdWvo1PQGac+GIliOPwbuzMHaIxPCGZc0X/w+d8AT6z
X-Gm-Gg: ASbGncs1Zevv5A9m2b0fXf94kbqVrxC4EhsO2AUS/Ixy4u7KNL8CTPp5MdmjLgYo7oz
	ot+Irgeh08hDYHZYxeOWfBDaoBwGoKV6/QTqqL0fmiknMm4OyrysA0tN+IkInTT67X1BAGwVkxG
	H5cJTuyVpkMU4AZivh3KPOdxStTlhNIpp7R+VqyACgis9T0QDUHQNnpsk6VKuCse+db/y0kOFVY
	I9xVU99p1TeCpPlGOQiQgatQS0ZiSxhWRsInQ5frKchc9bSTym7E1JF9x1K7/AXRV2gk7q603LC
	M8taSxldLNiCKHu1b4VZESSlw0WvjGXdzw==
X-Google-Smtp-Source: AGHT+IEqvuOOYMmlzyldh84Pi9ajHdpqofupXAF4kcQ30tohmz/xvgicdhHjnstZUDim0CopywzMBqPAovBY
X-Received: by 2002:a05:6871:153:b0:2c1:d224:bcaf with SMTP id 586e51a60fabf-2c7a3620a44mr159676fac.11.1742582948165;
        Fri, 21 Mar 2025 11:49:08 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-2c77ebc0b6csm96315fac.4.2025.03.21.11.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:49:08 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5C88E340245;
	Fri, 21 Mar 2025 12:49:07 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 52B22E4192A; Fri, 21 Mar 2025 12:48:37 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Xinyu Zhang <xizhang@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/3] io_uring/net: only import send_zc buffer once
Date: Fri, 21 Mar 2025 12:48:17 -0600
Message-ID: <20250321184819.3847386-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321184819.3847386-1-csander@purestorage.com>
References: <20250321184819.3847386-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_send_zc() guards its call to io_send_zc_import() with if (!done_io)
in an attempt to avoid calling it redundantly on the same req. However,
if the initial non-blocking issue returns -EAGAIN, done_io will stay 0.
This causes the subsequent issue to unnecessarily re-import the buffer.

Add an explicit flag "imported" to io_sr_msg to track if its buffer has
already been imported. Clear the flag in io_send_zc_prep(). Call
io_send_zc_import() and set the flag in io_send_zc() if it is unset.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 54cdcca05abd ("io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr")
---
 io_uring/net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6d13d378358b..a29893d567b8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -74,10 +74,11 @@ struct io_sr_msg {
 	unsigned			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
 	bool				retry;
+	bool				imported; /* only for io_send_zc */
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
@@ -1222,10 +1223,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
 	zc->retry = false;
+	zc->imported = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
@@ -1369,11 +1371,12 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	if (!zc->done_io) {
+	if (!zc->imported) {
+		zc->imported = true;
 		ret = io_send_zc_import(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
 	}
 
-- 
2.45.2


