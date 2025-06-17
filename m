Return-Path: <io-uring+bounces-8395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B2DADD094
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 992C41941EC8
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3C920E71E;
	Tue, 17 Jun 2025 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZNFCmr7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F97D2DE204
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171648; cv=none; b=r0/xg9d9KIvOP/yfN+nKob25Cib7/iHqxXEl2tU6NJo33eBqqB7ITmJI4KcfuVCD1LJTmgPdk0DNpby1k16yqrQgVstHOAn9c90Ua/oxWhIab2OE9wSWKWICRJi9OCFY+ySNiWcOH30ZvWm5jkK+qTIUz0MJ5ZgMx8U+v4mq8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171648; c=relaxed/simple;
	bh=cC6Is9XJQdpBKgmtuoTqyTdz0Qqf7IOduIFR5s444AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to9ISFqYmcNKMi8oV8n5bIEYEY5QrSawRgfvuf5sl/UitV2AargYeiKGg6tvxcMIQsf3m3dT4P2gG7fTUwnpjyv8P9j75F3skfwfcmbVb+YfxZPfPwHUeKMuZBIz07sAYT9QjRrEKGut6ZpEjeTbIjtw0JqAcZnAnAho+WOqfn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZNFCmr7; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so12299430a12.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171644; x=1750776444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umNizuxVra3hm9vy+YPJnWbstIVhMIhSu8lbCWWeOZU=;
        b=VZNFCmr7HwZon3EdiqrRllBoJFMWgH+JMIoY/pNg6tfiFgRvKiWKyQhB3mEmpamvx5
         mUT8fozAUubnNrZIQke8qq0urG+xtqh7JY6zmC+8L4eJxN8kcVC4xpvEqqT1Sxek4myZ
         nI3taulPsQXs60bHJS87gqmcBY8oBfwQ7PwjtlUn7y0UMUwYQwGGMLGjMFw8WolS5sss
         sJ2XWP2Wmtf6RIUvLtbN48rcmycyHnTa9AVtVuXzbsHC51aaxeUy/zdzB3xCgwP/UXjL
         xY7Cd5BgItllma34ebISu3M0dW5jPhWtEqiS7C/wC1P0r69s/7Q1Cyg/RIozcGRVlJgw
         1i/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171644; x=1750776444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umNizuxVra3hm9vy+YPJnWbstIVhMIhSu8lbCWWeOZU=;
        b=V5wN4Dm/z9T7TTYaEUrA7vD7ClkhTUbAMRd/ikYdy2/9ULMVqz/DXxMIS7Oh2yZmD8
         OnU7CqM/fWF/MS9SqV590y19FOGXZ484RjcslTZ4ZA2FP7pnXa8gbqbzToxB5GwHt5Wd
         zxICQPmuQyunq6w2FzShMQk6vm3os5hlth6XuASNfTgbwiAxIj8aPeUBG3iunIAsFoKG
         xyI9IwdpAP1e7a0BPjGyr1vYMGKRaf8fJnqHKfinMh83cMWd6GZxS/eAfmmIDz41EHks
         JYrJhftkZbvIfdznaLyMNOz1WkcI7POE5PhlSmFP6znLy8a4vIgRyJfGmytpQS3//BpJ
         QmnA==
X-Gm-Message-State: AOJu0YwzodZzlnMqqVvniS4xV/HP9ZzZxaOwSf17QGZ7nvWi/vo/rkRu
	YAVFFZc0uXYqJz28FtIT2dGSUoAMo4+DxsZrZCT7XF2eX/ATjeqXKwjYvSWj5g==
X-Gm-Gg: ASbGncvqyGOsj8CNk3IHaEL1fPHSvoxYy/vIHlZ9NVDaUacannbaHTLngKNUdfczOJ2
	NKVwjYpZ1PstpMjbYTy1tptR4y3Xnh19FfOkTAN5kNhHXsktwtRZDYpR2Ebn2ksVR1Stz96Uk7k
	KTxUbce4VHK/M7zFqvu4YYAiEvENIX3pJtMV9+BjwsoM3ssnbbXVJJ1gMEDhRVag26y4dt7G7DW
	9AJoTA0Bcs/i+lbu2cAnNLrjlPjA7lCmD3V1vW76pNpJdLrozFyW+G62GJaGdvamhfSwTbVIA/B
	VoL8G+x7Ijmj/FzlZEMqL/5uERNqA6/AevMktRNa15tH5A==
X-Google-Smtp-Source: AGHT+IFJNnxlzGv+sasGo0jjqLRkx74VPn0MW1nLc5ekEPQBJVP6vJFtIasVyhgJWFbZ5fx8K2/xVw==
X-Received: by 2002:a05:6402:2355:b0:606:f7bf:86f3 with SMTP id 4fb4d7f45d1cf-608d0835d3fmr11728308a12.6.1750171644533;
        Tue, 17 Jun 2025 07:47:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 4/8] io_uring/zcrx: assert area type in io_zcrx_iov_page
Date: Tue, 17 Jun 2025 15:48:22 +0100
Message-ID: <bac5726d5bf7f2f045de22d2073a95dfffde48e9.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple debug assertion to io_zcrx_iov_page() making it's not
trying to return pages for a dmabuf area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 91e795e6ae1a..a2493798e6f8 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,8 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
+	lockdep_assert(!area->mem.is_dmabuf);
+
 	return area->mem.pages[net_iov_idx(niov)];
 }
 
-- 
2.49.0


