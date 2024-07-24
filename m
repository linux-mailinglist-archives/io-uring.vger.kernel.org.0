Return-Path: <io-uring+bounces-2572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5E493B44C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 17:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB183B2102B
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 15:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A75C15B15D;
	Wed, 24 Jul 2024 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U2O2Nc8u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C381D699
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721836350; cv=none; b=g7HCTZfphxOjpT5hmfltn1BPC1m1mrDX89CI29dcIohzjzRvfd30LMaar0e24BawMlUbMLjkJnM63vmIXTYETsgj+BdvuohyYDj9uXuIw1YeXpnjaGNTURfzHZ19DLRqvp7L4qA6xXt5H/aV+qwpVsNN1SVYfV44tgBHDW7JvZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721836350; c=relaxed/simple;
	bh=Y5Wt6yzlkZpnhf7LxkTNpQBph24wwRM3v0dNN4QBDYw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YIKJmZ2O4H1PhKRj33JOj3aX3F7l/LJaETXIn5blf8a38F8ngP5rvtCb+q3kLTYYjlKa4Lc6LQiD0IWmOfWUZx5gGllYZ+EN7ZJES6+dPlGmom2/GTF5S1lTE7l+bZ8TCePLSI8I+oAsze3q0owZ+9oHNmOHJlAV4GiC4O9BJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U2O2Nc8u; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3dab349342fso275297b6e.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 08:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721836346; x=1722441146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eqF72g27VJ5ntymWsjv74MAIbfd/Q47+9nQBL7Gyb68=;
        b=U2O2Nc8u1cGUoJwRyXrSIOhoLZBlyyBeNemEsgAkMz7O7Fq/YMlNYyDFB0AcqO7kpf
         /3J2RufNpwxHlWj86qdxd2vN4JPMbl0V8dmaw14JJGQpZUYkljIUonKShvoLp0hXRRMb
         YhCy753DDoMkKRj91aZCCiZMK2Egw3oBA+NqgigGk+GjlJ1L52Gw5mswXgYAssEuInKJ
         VUWds88G7Yp2yG1kQOLZmyKYNYTozunP96fp7fpkmvidgh05KWYwefyBQ8UuL/fF9NoW
         4FXjUWKwcxCm55BR6uWnAsskXl9ejikRgw6dqObKso2xcgtDDZXu9CUqdyiqFXKbomsz
         V+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721836346; x=1722441146;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eqF72g27VJ5ntymWsjv74MAIbfd/Q47+9nQBL7Gyb68=;
        b=loL1wXMIsyMv4xCePswjSCP3eEpneaL3DQ1XNrgAucb6rJ3QGU3Kdr703kauaNn7sH
         jo6un1SsLicU+kG0nviPn7AtuZnFYTV9wvqtGUH+1TGIVh3jGQrLxr/GKrVWpSj7QdCS
         OU/Z9iCsrNWbSEJTiK1ewXi81OOSu5fRkhw4Pz2rXgVaGpXPXqYm7wZoOYVvSzmBf7Zi
         aTb32v5YIOj8HWMsveBRGWyyxNeiocjqVE7Wwyvx6+5dFwg7fSMKldNP9+rO5jEnueJS
         2J9rFgfkR7LrAJHj+z8O1K7oR5eDnaSOpfWGuncdy0nWu/D4Xsx2QnDPlgSVRsJDGT4+
         uZbg==
X-Gm-Message-State: AOJu0YxHjsWa9NvY7/aK3B+Hg6S3KOZj948UEMbgtUN0/O6C/+oDRFVM
	Ak986Ek6SL471vtQEEGp4Tr5lnzLbnEN2+xwyIxaCTefqTMPLG62LCym5A1YukJxm10KAQ6xZDb
	/pjc=
X-Google-Smtp-Source: AGHT+IHKodtRxCpu+ig6tBR/PObK/rsbaWdlj8jGDF6XKJEgRo9NZtzTXtCRl/UBr5ws3bMcspVtBg==
X-Received: by 2002:a05:6830:44a4:b0:708:b80d:1b69 with SMTP id 46e09a7af769-7092e77355emr52937a34.4.1721836346153;
        Wed, 24 Jul 2024 08:52:26 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60bf24csm2463281a34.18.2024.07.24.08.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 08:52:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/6] random fixes and patches for io_uring
Message-Id: <172183634535.7375.2594656224589830373.b4-ty@kernel.dk>
Date: Wed, 24 Jul 2024 09:52:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Wed, 24 Jul 2024 12:16:15 +0100, Pavel Begunkov wrote:
> Patch 1 improves task exit cancellation. The problem is a mind
> experiment, I haven't seen it anywhere, and should be rare as
> it involves io_uring polling another io_uring.
> 
> Patch 2 fails netpolling with IOPOLL, as it's not supported
> 
> The rest is random cleanups.
> 
> [...]

Applied, thanks!

[1/6] io_uring: tighten task exit cancellations
      (no commit info)
[2/6] io_uring: don't allow netpolling with SETUP_IOPOLL
      (no commit info)
[3/6] io_uring: fix io_match_task must_hold
      (no commit info)
[4/6] io_uring: simplify io_uring_cmd return
      (no commit info)
[5/6] io_uring: kill REQ_F_CANCEL_SEQ
      (no commit info)
[6/6] io_uring: align iowq and task request error handling
      (no commit info)

Best regards,
-- 
Jens Axboe




