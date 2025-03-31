Return-Path: <io-uring+bounces-7316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01898A76BBF
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EB843A3CB9
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8D61E231F;
	Mon, 31 Mar 2025 16:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xfzqq5K2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF42144DA
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437808; cv=none; b=pldSbh/jqrLtAYhZqTzf0kG2+348MW+Y23px48jIiIEYnsM2ZfMwvM5NGXmJeioS4f1lR6GCE8BzTqJmu62fh8JHW7utJx0rxyI4xsg/JGtMoKYhh4H1UFy2s2MoNwynXc0zDJCWyPr/+CFTumNyKJkteKuZVmWByMTgafohfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437808; c=relaxed/simple;
	bh=aHBCv6NOuvFOtQ8/riwKgRVcaqAaHoimjx9NdN84QoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3hfWzBPbdQQiKi4iPdIJXyZQnLXIYuUbl4jK5dfYGadXYCjKEJbEV3XaTHci2WDQSCD5kHj6HMbh7JEj7a6uTGQ+K6StShzwZv8NeHKpAIEbDaVfrbVVjUXqreJE/wRKbYxlbqngoe7CmgsGAszXQBSExyaFGUzRvY7dtV/ns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xfzqq5K2; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso1918686a12.3
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437805; x=1744042605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/3p+042K0g74G66rMt8G2VWKdQ7P41/rtQOOyBC98o=;
        b=Xfzqq5K2vVUkX2OEFoVvO7D/nidkCwoNPG7P0xRF9i3FiVN8ILgJaKP4/AJVDchDaz
         PbLTF7D5HMH26D12M/5yv++onYqe6TJOKH4/9wydFbmrp1RSRnQsxjAYTXBZCOj07Ygd
         5UZmlJUDbMjIOg9uJ4xyo2fW/NoNpCo0BQzZ1s0uKas89g63l+C+CuRv2dkzo0AxmX03
         4ZJYketXscSq8zJnSAb/88z6eEjy1sj4R78/WYw3CvEI212wUvyiq35iisFlyQM6LK+f
         nmNJblPKXVqv9ygbXFyCYBkQvUvChtHowzJLFTxYm7WfdUAyeWxskvfVrO5+fkE4PEOj
         mcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437805; x=1744042605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/3p+042K0g74G66rMt8G2VWKdQ7P41/rtQOOyBC98o=;
        b=bIxklLR31hUO7UJmutgRcpTW+S/uM9g2duHFQQEAg/ygyTkwrc7Di27CRqc1+NpN3X
         NDzciQ7CCgGFVRKV/mtaLjRr5PtSqpIzxeXUU/3pncAFY++WojabOqhszQ3BgGF6Z3hB
         78sTj1M0us9uu3Aq7/as4zi2DsGgWYtDFUzGXuouWhZ90cngpKwJmpADw0TQoVy+gRmX
         mj22UbumWAEKyajYjqiqrpTRg8gO37ymhDQQxb04rsIDjfxFZs1FVX9M4G2iGWkvCRXq
         vdAZ1UWplJVMJcS/K18dvm8YdN6r/ApTxyJP/v5dN13hw17CxnaQaBBMBgTAbZVq01L6
         OjlA==
X-Gm-Message-State: AOJu0Yxl/2jH4R9ps34p0cEuqhWrnrKjtsNouIqyjWEt9L3t9DHHMJqj
	6s1Z+frtef6hDrgEo/BARoGyCuDa+iJDVFIDzh9a/bs/Pb2MuySOf8sXNA==
X-Gm-Gg: ASbGnct8O/6VwXkNZ9kl6R8F7oAFn3MaM7n2Uh8lPJ/7ACRBjZy+h7Jk+spl7urw+U7
	2H+oa71dO/LCw79B8n3TfU7ptWV6hT+dvX0vJMsrG62T9Vr5LPzQ05fOzU9oRvDRZZWRL8Lw+hH
	PT9IWTyT73Rh2mQw27+71hUsvVmHdD5ZngP9FcslqtBUnYb1Xs+l34+o79JsTUwZp0An4zguJ4j
	HDosOkWFILUyrDNHEN8UFp9PchhPniug5cKQAvQV4s6CYajiQuBZJu0moKZw20qQwsRYQDFPVns
	2Zkg1efRCRCztV/5thn1LUkv3Wcv
X-Google-Smtp-Source: AGHT+IEeJLGonok/8DFmVX0Vq/dcuqNOpT7Fzp3zFSoELAImdznkfA7yu+ivcXxcFo8v1/ImGX1/HQ==
X-Received: by 2002:a05:6402:847:b0:5eb:534e:1c7f with SMTP id 4fb4d7f45d1cf-5edfdf1ccdfmr8235240a12.32.1743437804525;
        Mon, 31 Mar 2025 09:16:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring/net: avoid import_ubuf for regvec send
Date: Mon, 31 Mar 2025 17:17:58 +0100
Message-ID: <9b2de1a50844f848f62c8de609b494971033a6b9.1743437358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743437358.git.asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With registered buffers we set up iterators in helpers like
io_import_fixed(), and there is no need for a import_ubuf() before that.
It was fine as we used real pointers for offset calculation, but that's
not the case anymore since introduction of ublk kernel buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index f8dfa6166e3c..3b50151577be 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -359,6 +359,8 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kmsg->msg.msg_name = &kmsg->addr;
 		kmsg->msg.msg_namelen = addr_len;
 	}
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF)
+		return 0;
 	if (!io_do_buffer_select(req)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
-- 
2.48.1


