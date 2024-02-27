Return-Path: <io-uring+bounces-786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F269A869F89
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928CE1F226F7
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90E01EB20;
	Tue, 27 Feb 2024 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MWuEC8BN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4ED3D988
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059933; cv=none; b=TLz2AkV1Q3u/5eHMDBBGQ+ErqQhg4x03oPuAQBNK97Jw3Qgdf5Ty9Mrn43qMIJudTdTHT71YIUofpW36XRGqkvM4zVjfqb5wN3uWdeRIvonzfMExW6VzaSiuwYKHX6Q2OtK5y1sznKaIEmrGpYqHYq9pr3yGYDVXbC5z+u+Qp/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059933; c=relaxed/simple;
	bh=AzloIQMD/ciKtKnTcf6jzp66kEgISZi5bafMUKbL17w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=H6gnOp5HtZV2XVQOW13Wsb/SSCTUJXpe72mralvzc6GEG1iTkzzf2ujffnPSq0I0vqggCcsZdx+JhGfUZdsaFCWlW7JXpK/ImKbH30qWepmSuNnxTkacVGW2nqQTVE4gfWudwdN9n2+QA6YrorW/KpqKWCrxxZ7PSQVNs+bT/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MWuEC8BN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dcbf3e4598so503535ad.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059931; x=1709664731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gvsHTTj69pKs4jFH6XZp3vSYrvPlLQdOrHkbUA+GNCc=;
        b=MWuEC8BNJphHe5EibEN1FRJXSlviU2CD9WgqkfbIlAqfsgOx+e9VL0yR7WNJPaRxuj
         ivfmLs1zHdQ8ugQgLoidw1fdD3j8NTLqtvyCW3iP46SuPz6U4JXP6PdOUl7tF777bDOm
         M9p0JxfYS5ogJ4cfbSFQMJk2bVti0Aob3Mx9DMqDnCOH9Q/6gmjtNe9XRWth8wimiXUH
         TZTp6S8y3djsI1R9qhZI8wtRCMJpb0OIuWo59nX8eF90d2uc+pR7yE/idXWVgiKW7mBR
         5hR13BjjUTnboxcz2JXfEIHO1ElhpU8p4OP3wOsCfFA8EEecpbThhAbbOnR7If0Km6hz
         FUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059931; x=1709664731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvsHTTj69pKs4jFH6XZp3vSYrvPlLQdOrHkbUA+GNCc=;
        b=YuHSHDKlnJF21f+FWE1Q2rWEuQlYOIs8kUrzzfc5ypr9MWtah9a5JXhTSATDPH5Y4e
         nnQZiElzqIpQAcxsICjd5KHp1P0pUK4R82epp2RD5tBvztEZIs09Q0tAlGU9Kpg8nyzz
         2uGkoJVbiA/jcXjeegxgTfcd7FDSD7sY75oF/Sr8xaTSrvdYfyycV5VwuRuUFJYRSUbh
         nSM8QJO0NSjkiYz7z6p2t2saQVcz7Rlh+qdsie9qtjDKnk/OO0IEXeVA5QJW4PBThQJi
         GLzetZ4ArPiSnk4vZ1hL45CpjCxYXcAOzt1TfhiXATuvW7ZnVW7a5p+eq/8QXMehc1Zv
         D65Q==
X-Gm-Message-State: AOJu0Yx2q3Lp6JfRR+QhSuV3bQj3Ukrha9/PZHaKhvYoAqC2+fSX7VXx
	2zvM2HG5mD87n1SFhUvQCPXw8o8WwnOTdrDVBn9z4OEuoO4J8rFKrPZP2gKAO/wZdUKKeghzsRU
	l
X-Google-Smtp-Source: AGHT+IGG+HjgoueLqQQdqVZjyRYeQV+dK9GfSpK3VoyoVL3p7DeYFLBEzk8+anIWmIVzSCnXE52xHA==
X-Received: by 2002:a17:902:8495:b0:1db:4b1b:d726 with SMTP id c21-20020a170902849500b001db4b1bd726mr11262413plo.1.1709059931189;
        Tue, 27 Feb 2024 10:52:11 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902eb0500b001dc1e53ca32sm1860721plb.38.2024.02.27.10.52.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:52:10 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Misc io_uring networking
Date: Tue, 27 Feb 2024 11:51:08 -0700
Message-ID: <20240227185208.986844-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

In an effort to condense down the send multishot and provided buffers
support, I've rebased these to be head-of-queue. 1 and 2 are connected,
and we'll use 1 as well for the send side, and 3 is just a generic little
tweak/optimization.

-- 
Jens Axboe


