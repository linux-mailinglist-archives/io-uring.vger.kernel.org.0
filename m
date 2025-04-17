Return-Path: <io-uring+bounces-7507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C646BA917E5
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:31:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39D1D3A75C8
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BD21E9B15;
	Thu, 17 Apr 2025 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKYMc2Lm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9011898FB
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882305; cv=none; b=HKQItNl8oNgZHUt3v7DisZjvy2QX+AsMHNLA/jnE+phSNJm+iu0ad9f9E705vyRxDtTkoMyv/VrbABU70OQcARn0lafHI2xdsXRbWeoDbKizTO0RoIxBB3L0VL9SgfITLiiPsXWtTk3surooUiH6gfEKFUNTRbUFVqhTGbSRZqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882305; c=relaxed/simple;
	bh=y7k8XR75DUJnewdI6EuYLqg63icLFSdlfaCdJKdECo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HIbpnf9vf1x3n/fZp+SFWWqHOvsbCNt21cSiPEN/mG/9wmNJG+nPq/rw2cNlTTR5K5+0SFKS2dDsGFXvN/2/3CLEbSWO83CrB2H4sbrb8cl0wTF4T1eDlITBQ+k9pI04AINDElhjgT25bXt5VhMfpGmdacaWqOrymTR3C9us+Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKYMc2Lm; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abec8b750ebso83590266b.0
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882301; x=1745487101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KpP2aUS9LTTYm3wUzzW8H+onHHAeWLvl6yP5Zvwafl8=;
        b=FKYMc2Lm1FDfQWtCodw5uqEkF9zlW3ur/je6TSOCwN9Z4GtDu/CALSNDP0ehDZ6EDt
         MMBcz6HG7cRjru0ZUGeJbw+sRo2Demt3KH8fwQgeZA7y2ZoydepmOfQCs1B1G3xM1QoX
         Eqlw5TVzbIueJPZzACXP6qCyQH7FiBmjmBS2dptUAon2DFucvwyKFG+D0KP5DMP7+dLD
         FC1sv9eouM9qe0AxVg2s0FKj7qLABoQ6zKWpR8kH37LHNutC397JWrwhwspu9raIe/I9
         hnqiShEPBOC37iv+rnOxtdJ4d4STtOw9VNw7cU14XxHyGUZQBjSH4rFwc+OdRdOhH7Xj
         DDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882301; x=1745487101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpP2aUS9LTTYm3wUzzW8H+onHHAeWLvl6yP5Zvwafl8=;
        b=aHdI3VidR5Mh/r5AaTBHrbPZDD8/ejnA+glJPlPXqUs/u6MYjSNQm6EsPzukQhhfek
         PmTeNqQYMoi+GQ1teIZZxifpTuZQagDDInKQG3GFrHDDwe2wFJaIT3Ajuxfq0eIeK2vq
         Tf3PyeT96e44Zy/g+7BtfL7t+t4WKMwVOUZB+WLDimHQl7zgtjrHwpQyQt3SsNgAtObJ
         m1zJ4hY3jzVwFEQcf+eJ3dTaA06PQq3hMLipmHh/ht+4W70NZ5tV+pYNkA2XSDjCC0Od
         e3NbRGJhNvqIQM5BX9ZU+xUqKs9Ng0z0p7SNGys0W/u8FwnZuRA7NYQi0eUNBVhKNfgb
         8rbg==
X-Gm-Message-State: AOJu0YznUPtCGf843l1Hn78lr8ClYZY0O85eIdneaVgKAzUs7w2ARq3h
	jRDAPbvy2m+T9oKCH91FzMIDEsq2XAdnj+uNU2Rs55JiubCcGrHa9Z1Xixnp
X-Gm-Gg: ASbGncuMzAYQhf0FVqGGDKODpp19uMXtCZo6G4sCNOqzZ4r+jJtwVzNf1wfU460Khfj
	+lIqDBr0LDlXjhXjs/SOuW2klFyPFyLJ4/dCDI5CvNkq375o0CLx3oG6rU48SkAQnyrb+jO9qdR
	uhVcghDn4nlFDE4LyVMs+RDRP6if0nu4jbL+hhbzwSMlwzN265dIJL6lHFZng2WyunAmjOf94h6
	a0O19tPP0fjKGzA98FQ0YVLuDW/l0dAci2fAnWSL6J8a66XH4Ku++bPqOSuLdN4J0oNLBh19xpS
	7SQUbL+CmONBCFtqxPcvo+jOPfhEBt9xYvo=
X-Google-Smtp-Source: AGHT+IFbEaTM6p0MSr0VlZYm4tVoMbIL6Rr/QjaS4WonzqT1KWGpAkHCVE8nlFoub6oWaHl+i7ygeg==
X-Received: by 2002:a17:907:7d8b:b0:abf:4ca9:55ff with SMTP id a640c23a62f3a-acb429ec247mr370345966b.32.1744882301112;
        Thu, 17 Apr 2025 02:31:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb62b93234sm51717966b.86.2025.04.17.02.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 02:31:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 0/4] io_import_fixed cleanups and optimisation
Date: Thu, 17 Apr 2025 10:32:30 +0100
Message-ID: <cover.1744882081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_import_fixed() cleanups topped with the nr segs optimisation
patch from Nitesh. Doesn't have the kbuf part, assuming Jens will
add it on top.

Based on io_uring-6.15

Nitesh Shetty (1):
  io_uring/rsrc: send exact nr_segs for fixed buffer

Pavel Begunkov (3):
  io_uring/rsrc: don't skip offset calculation
  io_uring/rsrc: separate kbuf offset adjustments
  io_uring/rsrc: refactor io_import_fixed

 io_uring/rsrc.c | 74 ++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 44 deletions(-)

-- 
2.48.1


