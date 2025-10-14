Return-Path: <io-uring+bounces-10002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65177BDA354
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A608A4FFE9D
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28E42FF652;
	Tue, 14 Oct 2025 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP+D2uBg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A42FF170
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454108; cv=none; b=qIfIlWoDcwF1VkmTegQjhQLk+coto1JKK6XyIZ77QfHH7NHpjcNadZqffZjzsKYmRs7VX1F9foX2S5Tf80UKH9oqQueP5x9xvpgGJ/j+qI58vDm6QHFucmyi0SHNiQDaD0q/M92PcsqE4lvB1bc8iWEK7NvL7qheXe3Lo2RDcKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454108; c=relaxed/simple;
	bh=UwBBgNMEWe7Fq9mr1x7DhnuEFf96EMYoD9DMmVzLnUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dp3F7Vu76dfIQZOZIQ0XNlmEoi3Lt4eVtRimvxX2taS+BItVfPoxK+wSNExVUQrbopNCy/WLT07PWOliyipB8qCdQHZl4POw18tNyOjjmYIC+27dgECoInQQ7/xxOMLMHG/Hr7xnqpuQi2b19uvt2/XkG5osdwHtaGbpJgJzgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP+D2uBg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e504975dbso32731835e9.1
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 08:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760454103; x=1761058903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+n5m7vYgc1qGdrQz7ViMfaycJU9zReqvM3Al6om7lsI=;
        b=DP+D2uBgPaMQGCJ9yXx8zDY5wqJlfCe6tExrlO2vEJxlLbkl3RGfkIsJf3Bka+9Cjs
         bnZGE7QX/gESu6ANudEEXFTsQlmzOY+pl+F6q2PpQOj88qRcBBDd+P0cG+Xak71cx5+E
         r0CIT+TCRFNRmEx8znkiaNk/EU+M+Fu/p1Yltam1S+X94+w6FxozvTpMoUkZLK/sMfYp
         yDOHxIbKxzaExoWuEhaOqb+WUwFkdYSdbcUdt2mwFLOaXJQpfzg67eZcu+BlhUiBTcAX
         lOlxlyBI2lMCxZ+HnuzlTAAWx2D9hEIu0Emc13Jl88RC3MDvaFHAxYx9xChjR7e3aJDb
         J3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454103; x=1761058903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+n5m7vYgc1qGdrQz7ViMfaycJU9zReqvM3Al6om7lsI=;
        b=OZNg0eVfG4TSlCBD7Gv2cib4jZD+YEdUThA8pruV0tmiz1VyrUHbx1tTOAk3r1JOpt
         TEqmSgF3JfzP2s4Dv7TuwT0HGdCA0hP1kGzldYqegtEmjGLDvst7auJq230gK5tqIoNf
         m/E/F7fssEsJGcl7ybZ7AKAHrNxzcW3zL7gInMsiPsl4TT/8gO/6625MTNfpKTAem9jt
         Oq6rPd9kl2mbeWFjB0Omu9E5WBZwnBgGJlgKUYM26o8tom0TiA1AMCTixkK46GgW9YRL
         NnIJGOYQuBpYg3fQaA7mF3eY4STKjaaQyzu25Lp3T7VjueddeU76ZmJCPvyXbuPZUAfS
         VeBg==
X-Gm-Message-State: AOJu0YxcVWqDKwF0jxV+DZUwPBOIfPyBYettSjpH/vZy9TP0n6m9ZugT
	zkMGaAI3MUZkHZ9l9WiT/N2HMJqdnu3h96ZW25B1EpJG46ugLgQT3uyS+yzQ+A==
X-Gm-Gg: ASbGnctBHEAQ9WWTf06It62zN21Tw/DYlw3uvpvmk9R/HWLxqfCuiGNl8lye4wwYDHv
	5rzHxApyvkip468kEaXHJ7F9pfARtnAt+SVXOjidMIl+M3W6n/Gu6ty14FP4s7EX7/xOuaj2q4I
	RF6fMr42FIoUp7jRqD+OMLlwoAdrhBXkp5w8RDpdedJSYHMMTVZpyT3F3NlftoGE13aL1jpLTw2
	mPA3rpDT1fxOb9DuitnRIFU9bagHhm8jV8hrl/yZtf5YIoPyOQrNMUjnu0hDFQo9f+j9nAYhnS5
	DNv+SzJx3eM6MAIWMPViy8EcX/OHqKFbGRCW7tCf25Pmg5UebPA4HUW9hbDFthH19mLh712Ke1W
	QF1keD2bntlGeYuRfqFO32qLo48OO6ACy1tk=
X-Google-Smtp-Source: AGHT+IFqSAdjvrO7VCeBp3CJ9i0SZbgVFx8wvCBjK+ywVphRUfFkZX5MyN3OsNrQLp5W/o4Wdy0s6w==
X-Received: by 2002:a05:600c:1d11:b0:46e:5aca:3d26 with SMTP id 5b1f17b1804b1-46fa9aef840mr184791875e9.22.1760454103133;
        Tue, 14 Oct 2025 08:01:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm243910975e9.8.2025.10.14.08.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:01:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v4 0/3] some query related updates
Date: Tue, 14 Oct 2025 16:02:54 +0100
Message-ID: <cover.1760453798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve query testing and export a helper to users.
There are no man pages yet.

Pavel Begunkov (3):
  tests/query: get rid of uninit struct warnings
  register: expose a query helper
  test/query: signal query loop

 src/include/liburing.h |  2 ++
 src/liburing-ffi.map   |  3 ++-
 src/liburing.map       |  3 ++-
 src/register.c         |  7 +++++
 test/ring-query.c      | 60 ++++++++++++++++++++++--------------------
 5 files changed, 45 insertions(+), 30 deletions(-)

-- 
2.49.0


