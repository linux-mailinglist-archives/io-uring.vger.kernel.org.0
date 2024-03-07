Return-Path: <io-uring+bounces-856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0067787585F
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 21:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFAD4280E5E
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 20:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCBF24A03;
	Thu,  7 Mar 2024 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fq4nS4of"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048AC23772
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 20:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843480; cv=none; b=QpHWimRNbAlZUplIa2WKXelMFWBJ6NeANSudxtfpcHVQjc3zzEh4fmyNUweK/owi9eJH4FqHG6TmEHSp90yjjX79PluiW6hRpk4oUOefIHnuXvaiI6VV6l0BZHLc+aINjqqqH9V1yU5S6DwH5BE4srekF0zEoL08VNFfM0p4r7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843480; c=relaxed/simple;
	bh=UIrAvTmzOYfX8oE/AbHf8ey5vR6IW2YiNw52vpI9OwA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=J1BlNJXycHrFnrmIjOxx8+bIjYtTCutbd0RQpoVVgoG1hRJcME5/8C/BqqhY8n8XCPVn6/9RKWt6NM8i1OALLdoyu9ZkfdXR0gzLpxQtPOeaP1P8qRAu4hnAbx4ydtDz3W9rAHjCZAN8AqGxzCuOd6kMsRJpngVvmWW/0EWNHmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fq4nS4of; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c7ee5e2f59so4717539f.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 12:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709843476; x=1710448276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=K62eyjPxAFSyUC0ntHOWoswx7bSCMi4v+YC63WTLwto=;
        b=Fq4nS4ofCkl671/ebpXa3RoM/BJqvtsPV5M//iYfS7LdNcjg42Zr1R9WKkOAhSHAae
         DM8vk1tIiIKKtU8+KwkXxixiVG9H4jk78MtFeYOEBf7Dx/WkP6VBqjh5OzoAXPuwOwt7
         oWGat72g4iz7cb7tjqbIy4qqNvGdpvv/EIUR+/VpcTM3UwMTMJ+XE/0cGYPPizaiRpaL
         F3kGSdgzrtZVaH9488xmVAdPPH8CLb/2iabocK6XGx/f57tVm+1TqbkixgB+lUwT+7ST
         IsFh1ZAqvIx3tSJfFfUixKwIL38rwMCd1DeROBlkku10xKQ1DyezU/PpIw5b+LKCM6sw
         Th+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843476; x=1710448276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K62eyjPxAFSyUC0ntHOWoswx7bSCMi4v+YC63WTLwto=;
        b=eVM4k33lF95h8MunTXeuHc4lnYE4Lxai3MiJHAgdYP1OpDTKEH/IcIDQ9QQpNLQaTg
         ppS5dBEizgV3gfjZw+0gw3zH1ruGetC0FtBUwbu4u2Xv4z6NIPRdKvMw+A5tvPnGebpM
         eWrPXBcjFVW5V1ZFsOYP0Iar/j0uVC99LBEvnnlRzziD8XK5DvtN50wcK5kfpSmwn7pv
         QJda8qQCUMWxz5qpVM42+eV4iUFMFUmTbFgmpAmqsf9KZNZEWLYlM0cfKnzGe+yIK5i2
         gT3E/VY6q9guoS/Gk/gcG4NG8FMUxhL+MmLzpwZmeGpnJ4uMhpd923D/fmQbhsm3GVTY
         BKNg==
X-Gm-Message-State: AOJu0YxBauc1aPJLOtPQLUhk6IUWFkHvJSHVI/R14WTipy9J3gCo9t4J
	7R+91Y0FTelQ4tDFklsrWiOfoD8mkP/SGBNfgaVT5yjI9quoXSmjmxn4JGsgajUdn0z7CbysOtj
	x
X-Google-Smtp-Source: AGHT+IHWAB9sy0aJ3slgURaem5AtgIGqTiGFIgjeYA6mN3Ko09fpA7nrRVt0atVCchcJF+we/pLKpg==
X-Received: by 2002:a6b:dd11:0:b0:7c8:718b:cff5 with SMTP id f17-20020a6bdd11000000b007c8718bcff5mr3557176ioc.2.1709843475737;
        Thu, 07 Mar 2024 12:31:15 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b0047469b04c35sm4198921jai.65.2024.03.07.12.31.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:31:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Misc cleanups
Date: Thu,  7 Mar 2024 13:30:23 -0700
Message-ID: <20240307203113.575893-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is part of my recv/send bundle series, but they are ordered at the
top and don't have dependencies. So sending these out separately.

-- 
Jens Axboe


