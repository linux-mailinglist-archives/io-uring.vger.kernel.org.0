Return-Path: <io-uring+bounces-2401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B305991E2C1
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 16:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75483288483
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 14:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35ABF16C870;
	Mon,  1 Jul 2024 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fhxoab2V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED22F16C867
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845356; cv=none; b=NgCZeS0JDTj490UXFQTHWxXPdfcThbQayqDhkoW+mLgcNrbf8G+qIejtiB0JDOxUsNKH6cyxgHU+YcEZIpB41Y8T/gDv1lWQANtTjZ+CH2u9mSoFAV5bYrBvtG4ZfMO557r6QxANtgJ7xnVc+Jv7T/lxhmoSuw/vvUd08UTInoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845356; c=relaxed/simple;
	bh=HmRRxGNy6XhLBb+gxjvMG5VOPemszoKRn7pUhDo3U2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iLzZOiRxvR9a+sH7IvUcsWZMHMTp0/jvfS/94/jfrRkaciiZeLaYE7/eDUsaamxEAlLxBwTGV/CkYNKJyco4UuczJRYI1NIVe66w26o0b2JJhnaznq0eOXESsu/S/HUdg54jsHK5QKh2Q2g+ED6XY13sJuIpIqGb7Ow3LMwUW/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fhxoab2V; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5c4163df090so54258eaf.1
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 07:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719845351; x=1720450151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WJskHyuPcBsleLHDBXhXoNKGOapgTGWZt6jsl2tN+N4=;
        b=fhxoab2VUHv31pXObuWFJcL12Sfi8TzTIqm1u/G5c32HoRzuZiBrjcKorsZunnKtdo
         Rsp9DNfjCCiMFPlMDFG3rNjynJk2mOhWdcHFuS/EyVTtcYZDz7zeH4ijAJebGmRveFft
         FYtkWj6SMhPuhWGR6NEbEtGidywr3ZlshFRM8SXDL+M2XWJKxrelTUttsCR6yoq79tNH
         lflj/m41FoMI0p9i5trCfrT336hpRehXjT+/si1jYjP6I/MvrJIcqqoFzid3dCL23fu/
         DlsWQYeGSzZo4PdMb8YpTS13sEuwELYpWJutOLCv15M7rvIwKXS/itD+purEctTG9MJt
         gvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719845351; x=1720450151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJskHyuPcBsleLHDBXhXoNKGOapgTGWZt6jsl2tN+N4=;
        b=q3YbsXXfQdKXu5h2N1I7MLRGUkdyWMMviN7j+1n0+kg0dI6Su51m6FJVBC/pW1sBMe
         /B22NeBNPsBOGiNdHQGjP+uAF9PT/pC6QxBNbv8jJQ4DTkB0ECW730ppS8styGNnxI9E
         7E8juAzJUvWLoRmD8rkh9j06tkNpLwv4yi4PY03yoK88sXarqm6N0IKRu5GP4KoD4ZGY
         vJNrnAH6zqyyPgKZR2YiE5EWpXO7rL0BnPAelZixYlfsZkl+5lBSZY81NK1ZOHPN0tky
         0CbFNQ6MCWtT0y+oOpx45GnOeTdTpC/gPDsw0L6nvB7vJjTMYgDk6Bg+0dfmOLxUwuvz
         QJJw==
X-Gm-Message-State: AOJu0Yw8RDY8XlmEJe7oBxx5HmK1FjgV+YrRi04RJ6UJK01IVNMkeeHO
	uQDjX1YF/AFp4t9y8GtU2Q6NQL3/eCru3lPlzJfsFsBXlouPTwaNfV5g/bLU/tQFJ950qQDItIK
	UA1g=
X-Google-Smtp-Source: AGHT+IHYB+lCFIdBWHJA9DjLbpnZNSTmNl049m1Wi94f1sAscDKL85x6iT7WHnjLvwio3cOG/sGlOA==
X-Received: by 2002:a4a:a8c5:0:b0:5c4:5cbf:a255 with SMTP id 006d021491bc7-5c45cbfa2cemr772328eaf.0.1719845351443;
        Mon, 01 Jul 2024 07:49:11 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c4149396basm1025133eaf.21.2024.07.01.07.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:49:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET for-next 0/2] msg_ring fixes
Date: Mon,  1 Jul 2024 08:47:58 -0600
Message-ID: <20240701144908.19602-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A fix for the issue that Pavel highlighted in the conversion to using
internal task_work for data requests, and while in there, postted an
error in the caching where the wrong freeing function is used.

 io_uring/msg_ring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
Jens Axboe


