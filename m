Return-Path: <io-uring+bounces-10584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DD9E6C57042
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7379135651C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132BA3370EA;
	Thu, 13 Nov 2025 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W18zCLYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF0337BA4
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030949; cv=none; b=gLp4tE2SmBY6YuatR/CkxpE1p0UMeB9wMRHwyZAo4HqBGPwvFYynCV8YYcvcMM/5dlxxqqe5p+xu+msyFuMISKs6leRe+fqw5YsY2SnCfBIn1/+rtGSSYR8cPaxx4UaLt6uZESwqYEGiK/eiuXIMoQ9wbQavdaaDdC84x1/cAqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030949; c=relaxed/simple;
	bh=en3l3gNHhUFIemWPTODBQDH7X/YR3C/OoVAQVr2zyas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DF3Jp6Z70ZUWNkC6ASwEDfbxzR9DeSouO3n9AJIuD4xlU3sTQA25AUQ0LT+XOahg5hHAoVSzIAt11q5fi1L6nHVCYA0Pen/qXHYwkQl0eQEB0jK2XBY2MXMGhakYPivmI+hAk9A0eyaCwzN36RhpSKm1i9i9c33+fl7dPtuTlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W18zCLYM; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47777000dadso4688275e9.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030942; x=1763635742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iPKQhJAg7ens1xf07gWshSPBDBZ1ZqBMJ8fPZp3A6fI=;
        b=W18zCLYMScwXxOAgCOP29FfpOe1NU5x02kgvE5s2Sip4i/DbqjZ5BovPbHh50y4f8c
         85MC1NyKh64ylekWhg3Qgeoa5a/Y2blt/MmWkwmkKET7L00iPpp0wH6/OgwB60l1IiMN
         sAwsAuScXzRH07x7HXgXZQVe7FG3pGzkiktsmgyr3mww/HpaR6q14IBH3rdUbz/alsoS
         cTBCtKjj7bjxXbDlClvst8wIioPDq+CpMz23USMxy1Gex8JR5b3Qu7mWhpoU5Gj/ozsw
         rirX1MuJ5Ax1zgxHtQvMGBRVkaQdl55RKtNDbxMWfyPu4buJMODpQWsVvQfXBUhQ0Z6r
         RUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030942; x=1763635742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPKQhJAg7ens1xf07gWshSPBDBZ1ZqBMJ8fPZp3A6fI=;
        b=pC5w13iD5pQlNTgDWDb7oqAkFQrMx+II184OWqb8osWHvDnhyZssR42JJrMxN5Z5Il
         HPpcaK3xvFS/3RCIwgjodd4b33itjfn+mb0J74IOBfRHabrJYBVJI7WoWqQ5jPUdJEJZ
         4Qx6bMJSExDLejObNIDaTnfN3FXQnP7wdF2X4np4oHS+dhVPhhx1as8spibXQG5dVErY
         cMebQa3goGsoi0y3FkWTXMp8evoQdnOYicaAZy1qc9lnH1pZN2a6Z+HOeqbjxdIK2iKN
         Va+TVPiW2NDBJP42lfsXV1NdpJO5f6M0O+dvRFrmRklZAhTqJakTwzZElqQjyAF7A26j
         1vkw==
X-Gm-Message-State: AOJu0YxpEXO4aoPn0yZZb5ypBg5ZsPbm6ChZVosNjboVIdtYqkMMqBwT
	WN28Xy/0heIsujarVhT/oh6/nBWMBzmvSVwjUBz+2dIdQdw1e/Pu9qZiImOoZA==
X-Gm-Gg: ASbGncs2a+KaSWArQSnveXH5qCxfqg5LOpn8B3UsJjxbU8LXNzf9uaMKxROs60kAA/i
	4RgdiX0W2U8e8Jtu0QMM3IJcJ8mIlrjWJRDUhS3vGFOHQYFZOa8z/E5pvwAGIBKAIwr1tJ9ZfWv
	9Y06ljoWYneInZSZasJgpQgFDr8G7If5AxhyZWFrHg9FlGVkXzRJbTZW43fUQQlRF2W1a2Lzr1q
	djrGxzd2pz2JHqdKdQIUqQpm/MW2TlP/cc6Pm/JKTHxiT+ffsdFGkRu2KLX0PlKubzVcbMBSQrX
	Pa26Gr0yamqxnNanQCLqg/8zZep3KDNbDFYVO4NeKgCW8z1bdnfCHJ8eJcpEvxF2HqkB0Da0fyw
	MCOYNDjVK59AP+99+vlcZKpuQe7+UbWkUJURT8AmLVT2LfU3V0y+F1H1xisI=
X-Google-Smtp-Source: AGHT+IG2eqWjWoIQLXtM3wqoth2VdI2hRms3KNtXfmWBXhTMYf8ZYiSOwWUSDcdi7tOWwOXvvvgWGg==
X-Received: by 2002:a05:600c:215a:b0:477:89d5:fdb2 with SMTP id 5b1f17b1804b1-47789d5ff9amr26574715e9.14.1763030941952;
        Thu, 13 Nov 2025 02:49:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e442c2sm88850945e9.7.2025.11.13.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:49:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/2] zcrx and SQ/CQ queries
Date: Thu, 13 Nov 2025 10:48:56 +0000
Message-ID: <cover.1763030298.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: depends on the 6.19 zcrx updates, and based on top of a
recent 6.18 query patch.

Introduce zcrx and SQ/CQ layout queries. The former returns what
zcrx features are available. And both return the ring size
information to help with allocation size calculation for user
provided rings like IORING_SETUP_NO_MMAP and.
IORING_MEM_REGION_TYPE_USER

Pavel Begunkov (2):
  io_uring/query: introduce zcrx query
  io_uring/query: introduce rings info query

 include/uapi/linux/io_uring/query.h | 24 ++++++++++++++++++++++
 io_uring/query.c                    | 32 +++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

-- 
2.49.0


