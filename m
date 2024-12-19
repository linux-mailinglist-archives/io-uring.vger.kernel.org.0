Return-Path: <io-uring+bounces-5572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5749F85F9
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3E49165251
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 20:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC821A76BB;
	Thu, 19 Dec 2024 20:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="23puY0Du"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6B01A0AFA
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734640377; cv=none; b=NP4kKMQu73gJXfb+Ok//CL/Q3n8KJGDy7y0dQfB8oEzXrkooCqXFBQrrqu7uTeJ55Zed+YiSOVYzWG4ngaebII4VESJ1p7Zo4FHoU8M1caoSeSc/CMX07vprt089XCeeM9oBqI0iuXJi84DfzEKqWtXifI046J+j5iQr3RXRYzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734640377; c=relaxed/simple;
	bh=s5XabipMXHAMI2csqfblhqBLdKcWgJ1doKvigHoOYRY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JWahkvgELBPoGzLzOcM6P+sqNrinLf7i8RN3/F4TLXl5p+21Y08X/o2x2DHHxKzTlDjUOZgvRyqD15J+YQ5ZFyFB3nKHzgsHNiecgrK/ZadEf4Vakv7Hxgu87A7ckAo5CQmb4XzIuCTssr6ULlzAsnyY1Fw1Hg8HCyKn0g64OiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=23puY0Du; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844de072603so104390339f.0
        for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 12:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734640373; x=1735245173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5UHfxsj++x9OqXR69vNqk9zFGwVqP2m9DhMiQQv8xU=;
        b=23puY0Dunm/JL21rLfYlJVPhTqtUFzE3654Ehnj9lBGTdF4n++Cq+5QTvzKCd1fqTK
         oNA4ooEnBUBjhtcBPUK/IYWHBiInjBZl5E83XbUurRrQr6ikbymJr59bCLYA59GMQn0s
         16PFRgg1G3K/TBVAbKbfjS/hAjN6Bub5JqgexMfiu6pgODeVXRGHyDB/WiSF9VedoHW2
         +FaRICqrwIEROcqdkfiM9U4+lGWgfCQkd2qI8mOpFpnJhe8aGhNPrAXptjaNDVsM+sBO
         fVW+3VaMX0f0wFj0JOUMh9h8OcVCuU5L8BqxKsoQZ/FvCcV+bGLG19Wa1TyBl0lVOwof
         QqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734640373; x=1735245173;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5UHfxsj++x9OqXR69vNqk9zFGwVqP2m9DhMiQQv8xU=;
        b=pU9OLSTQpdywqxh9N5JMc/ORBYTthRcloQ/tKxUza/Cn0DUIMXK7b4Hii6kXCCNmxK
         A8TZiWwO1TRcJT1g6zxrlZ26xfGp/oa6JDINwcmqio3ljCyqn3xEFTc/DDJ6ByRN7kf3
         wSHezSLcrPlMB/EzNE1zFBlyNvGPVlzV/QuMXeP9HzFDjpG+qM08rSTKPe9SNmHrBh7c
         6whi7xAYueCbfeuArjCpSUasdLakvM1O8PSq9ZmjeqhHC8RrIjZSxAWAkUi0VUrMQERV
         KmtzKhk+MA7R7llsvK5V2zlpK1kc/5kx8iSJYAzyYYeNwzF+oBpJjKzaOuR5Pe5GsIYm
         dl8w==
X-Gm-Message-State: AOJu0YwASWnByo3dVZ+XCX7/5+DT6WFgIGvvgyt/UnXNX0TI+bWqh7BO
	7Ef8xt0Nim7eghJbYOyH3Y0xdYteop/SwjhscG6dJrz8DyDnkLBYQHOkDIuRgOs=
X-Gm-Gg: ASbGncsWxXFm83j1Fz65naOz7gVRa9I0YOn3cGTggWpTQgpCIiEOXuQVsGuAYtPYCIZ
	Q/sRs1IshLa9UlHSQjVUizUhJs5sg1s3gI6i5c2JnhQ842zFH9s8KfGnceaQPpiWUSqsf49U8MY
	x1pTiEJuNQEH3d82M36egMiAuNzeZmf3yZrUyC5CBpq1Axz83yeWt28istMMSrKOJeuMiDz9MoR
	cBpAhYr1JR9BmCNh55MW3ZUGmAOoOISbhJdAggcc6kie5c=
X-Google-Smtp-Source: AGHT+IEmpL4WB3+cyKnMiIcwGpX0BUq9wNSi2YWrxQ+xhc8oeGxZCb6mFslvwsDT9hLP07yFWFSJHw==
X-Received: by 2002:a05:6602:3c6:b0:835:4cb5:4fa7 with SMTP id ca18e2360f4ac-8499e6c0449mr16795739f.12.1734640373479;
        Thu, 19 Dec 2024 12:32:53 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8aae19sm44588939f.37.2024.12.19.12.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 12:32:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Will <willsroot@protonmail.com>
In-Reply-To: <63312b4a2c2bb67ad67b857d17a300e1d3b078e8.1734637909.git.asml.silence@gmail.com>
References: <63312b4a2c2bb67ad67b857d17a300e1d3b078e8.1734637909.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: check if iowq is kileed before queuing
Message-Id: <173464037242.998783.16891287792615272558.b4-ty@kernel.dk>
Date: Thu, 19 Dec 2024 13:32:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Thu, 19 Dec 2024 19:52:58 +0000, Pavel Begunkov wrote:
> task works can be executed after the task has gone through io_uring
> termination, whether it's the final task_work run or the fallback path.
> In this case, task work will fined ->io_wq being already killed and
> null'ed, which is a problem if it then tries to forward the request to
> io_queue_iowq(). Make io_queue_iowq() to fail requests in this case.
> 
> Note that it also checks PF_KTHREAD, because the user can first close
> a DEFER_TASKRUN ring and shortly after kill the task, in which case
> ->iowq check would race.
> 
> [...]

Applied, thanks!

[1/1] io_uring: check if iowq is kileed before queuing
      commit: dbd2ca9367eb19bc5e269b8c58b0b1514ada9156

Best regards,
-- 
Jens Axboe




