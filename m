Return-Path: <io-uring+bounces-2329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D531A9165A7
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5E0285F71
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 11:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413531494A8;
	Tue, 25 Jun 2024 11:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUPmAizM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB97C145B32;
	Tue, 25 Jun 2024 11:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313244; cv=none; b=NBxe8ERY+wXUuP7SA49f8pnlzFA0yb0igh2eS/kX3ODxgWMcfCEOsPpMgwGBR290lORX10uDIJKDERA3+zHlYUcxX8Ff1rxmNHRF83/WFoNTCY6YlrsaPk5uC+gyo9ViHCgu2hFe0u9G0V6TY6qRuNJ2fGQxfHyUrTWq69hEfdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313244; c=relaxed/simple;
	bh=LXxICpUjmWmSc4J6mlziHyd4loNHPBkcM3DAZ9CF3KI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BcXsAt7fuyHyAOWuL8OkP2+gKZFQoB8SrN/j/S4tjcfzeOnofwj/95DY4cYYbfs0FWPPHha3wVaULciD3btDj9fvKpeTF96Nhod8b/nxfOwv4izwSQmoRiaUul7RaYWJvc26KcZjIC14c9sbFVDisyyUnWHDffRFMkAoPqHMPC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUPmAizM; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57d15b85a34so5579937a12.3;
        Tue, 25 Jun 2024 04:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719313241; x=1719918041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGuMtnuYMDiDL1yEpiDAlqtm0FKjMnUCgN+mY3AbRvI=;
        b=SUPmAizMKTYrEYtZfor5nhLJFhIyAJje0MLZlzNrUm3rYs5V4FJzg3rW5cuBaiRt3/
         MebWsWZXwkt8PEPa2p3IWHuPlxXJ1nD1RkdAmWKLgyChcTm5dObL5K9TgqP+Yq5x1X6E
         OtmsMf5qVlahW8GI507c70E9SrZqIHFrb7/kASSAh/Eh1X7jwaS5zoz2seQW22D8Y0xA
         1GzkWTPiccXsDrthF4+o4c8qPy3dZzePAxyNHN9RmywIO/v9rf5phJDdUL1jSslWE4+i
         rR0nwGWyNkCV++74eIL5GftWCVkKkgiR8pcDebY86W5PQQ8xv7dq/pQzAnxntg4giyt0
         RW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719313241; x=1719918041;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGuMtnuYMDiDL1yEpiDAlqtm0FKjMnUCgN+mY3AbRvI=;
        b=FXw+eQOWLQqxLGHsiIp1Q6DleYLtlNTVWEjdAAkN9nfJr0uzdEvwMNlFLaa5P3gc1O
         fAB/azBr9a4c9h9evBptYhJwE670Rn95M5qOo1RslrdGnf9pCXKnhhAfZu37IlvpIs2Y
         j+KLu6yt+bD16LmVcjo2sYVjx8AoQ11OTSVvyTtJvCUjRK39c7BBGdIyFj3iHxzZqjJO
         8gq+qQez6ueO/1lkT75Vc+aFVdo5gDRVGFnQxKQUbjJnD2i+DiUqgBaigUk5hQiiYLJq
         kVmCgW2+qIZcM6kdLKZQlDyuxJOYYM+cotSISAs76vurMetMndrDpJqN/g71Gp6gS31m
         k9WA==
X-Forwarded-Encrypted: i=1; AJvYcCUeQWUrkWl91l+2YAYKEvoLpUyRuRUg5p9+WKJGzDzIKLVhpBPh8Z7qazZbTxMJRySHubL/s7teRprhY2Pnr5qa/2fECuW/rjY+yWYZkId6m/7aJDHq+rda1rS3/BxeHYStN/RpAeLlwJQNCrMUTqGstGk2sT/d5de9zBsFKdZno2H19FSE
X-Gm-Message-State: AOJu0YyMpwvC/TxOz/eMcVogD2kj3vTST97i4/b3UqomHVgRgvmNeym2
	hseiVWycUEP0uzUtTqYXIZlQiR35W5HqC+GZ6WbhAZzwNiuDrt4L
X-Google-Smtp-Source: AGHT+IFxDd53h1WFg33yA0zukb1pOePy995Sl8FyyEAE1kDCnsUuiOt6rCItKjhRfWIcvsXG+WOfpA==
X-Received: by 2002:a17:906:eb09:b0:a6f:c886:b68b with SMTP id a640c23a62f3a-a715f9799e0mr431429666b.43.1719313240713;
        Tue, 25 Jun 2024 04:00:40 -0700 (PDT)
Received: from f.. (cst-prg-81-171.cust.vodafone.cz. [46.135.81.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a724162f037sm337272566b.194.2024.06.25.04.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 04:00:39 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	axboe@kernel.dk,
	torvalds@linux-foundation.org,
	xry111@xry111.site,
	loongarch@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 0/2] statx NULL path support
Date: Tue, 25 Jun 2024 13:00:26 +0200
Message-ID: <20240625110029.606032-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generated against vfs/vfs.empty.path, uses the new vfs_empty_path
helper.

I had to revert "xattr: handle AT_EMPTY_PATH correctly" locally due to
compilation errors.

io_uring is only-compile tested at the moment, perhaps the author
(cc'ed) has a handy testcase for statx.

Note rebasing this against newer fs branches will result in a trivial
merge conflict due to later removed argument from getname_flags.

Mateusz Guzik (2):
  vfs: add CLASS fd_raw
  vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)

 fs/internal.h        |  2 +
 fs/stat.c            | 90 ++++++++++++++++++++++++++++++++------------
 include/linux/file.h |  1 +
 io_uring/statx.c     | 23 ++++++-----
 4 files changed, 81 insertions(+), 35 deletions(-)

-- 
2.43.0


