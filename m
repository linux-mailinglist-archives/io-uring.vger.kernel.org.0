Return-Path: <io-uring+bounces-2079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A408D8862
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 20:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5D631C22259
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 18:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF13137C2D;
	Mon,  3 Jun 2024 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q1uPiK9K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6721369BC
	for <io-uring@vger.kernel.org>; Mon,  3 Jun 2024 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717437885; cv=none; b=WQx1+iNV7j5WvI6OfXJc6ssQIey4M2xHf0ei2f4PBt8kPG5GFUiisBSBp8gKGTiyVR1dkhWCBsP/cvlH6N6xq49ortfepuhBRbxq3uAHhLXKGng02TOhAPFyH5ZYAARAM8aEH535uYKb/jUFXFHaZPV4ORWnxDmT8+hVZE0QfeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717437885; c=relaxed/simple;
	bh=ptUKPDJ9DwPmMDhrlbbk8ISt/ZJqD50mfhytcai8EhQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FWOEdpb/PNZrDJC8FiNye4zCk7TADco1pOUaacAnAHU+51PYaXjFI8WcUlaCPO5vixQF7yIiSTj1lNXiwfjRQYlEnfJw0sLlmL/dJlAJIA73fJlxJUq780iyL4NwJTddrJFBLx030doi/mdBHAKQjFPNuRBA2df2y0CgZXcXWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q1uPiK9K; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3d1a094b2b0so526736b6e.3
        for <io-uring@vger.kernel.org>; Mon, 03 Jun 2024 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717437880; x=1718042680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kh+tI4qqHtjPL8qSb60N7T3Xuvn6hrqxLEmBRemnJNg=;
        b=q1uPiK9KPiU21YoXiZai9V5yRzqujZVy+yHLPqw4dC+fIY1au9VQuszNM/HCKanC8/
         +bXHINQEgyGCJN84wxkX9hUdCcJdu8BKjdzxyQ2qjR4OehsOmUovbbeyOzcrgBd5Pb5M
         O3qsEMfKLqMAoFo673l7NV/QATLtg8xoIgkhNoUgT4miq15P5w+sSeCuGBUkw4iXNplN
         MNkNKuTHvNZjRdfSdHMwx5Jl4QRsJ3XUkc9yGJybNlaPP+e0u0940Qf5gw9N0C/SP4DK
         YAc1uVIdqcwlzEwezzmlXhgd+ntztqsTfdClFid5oL9GO9rnIA8PsCiOQkUaj2SoWgHv
         +g6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717437880; x=1718042680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kh+tI4qqHtjPL8qSb60N7T3Xuvn6hrqxLEmBRemnJNg=;
        b=BnCJGz1O5PFUES6UsIP3XAWU9j7FBjWr7obSBb7IN0+aGw2BzRUtF55k/4bm8JcKa5
         4q+wIsP1MwBz4CasmnupphKoH1dOvhdtD22emD+ewCE+9S1gVKRo2yMebuz/4/O9DXNw
         Mt5Osvmix0yV9mXZhEJcQm1PdLOlnkC+Bs/P+lhThTNlPKXBiDrQLvvJEwBY4c5FtW5N
         ml88uoMDL6PfbFI/FlU+b28B8gALAay8Zoe6mJr0oYCxIJ/jAjDt5UY4Sf9q/4RNNlSc
         5UFv0cEZd5oUOBsVOTMOYmvDJuMqYfuxKPGSFhI2I6tr6wvlMBTJamzqDGaWAf9Avpoe
         cl9w==
X-Gm-Message-State: AOJu0YzMQHOYRkPSCYIDxCiu3XgGAiBNetgdTPpu6SruPGY+OXeyPA8y
	2+RcA/wwhj63nx/0B8961sLOn7QZJU1mEnVgubxRyw710zgpYZkaY+PjK9NekLiYh5fWoAT6PD0
	l
X-Google-Smtp-Source: AGHT+IF9xbOMK1j9JjY+Vrq/sWCSEwbUGRTtDuwbdCXNHOEWK1e1UyNu7ahD/Ul8l06K3nk9S5Fjtg==
X-Received: by 2002:a05:6830:451d:b0:6f9:116f:af04 with SMTP id 46e09a7af769-6f911f23166mr10270288a34.1.1717437879940;
        Mon, 03 Jun 2024 11:04:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f910550371sm1564046a34.47.2024.06.03.11.04.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 11:04:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] eventfd handling cleanups
Date: Mon,  3 Jun 2024 12:03:16 -0600
Message-ID: <20240603180436.312386-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Patch 1 I ran into while doing other work, causing leaks. As far as I
can tell, not triggerable in the current tree, but I do think the
rewritten handling of eventfd is much better and more closely follows
the expected RCU usage.

Patch 2 is just a cleanup on top. There's no reason to keep the eventfd
code in both io_uring.c and register.c, move it to a separate file to
avoid polluting the global space.

-- 
Jens Axboe


