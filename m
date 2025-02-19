Return-Path: <io-uring+bounces-6560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB64A3C321
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 16:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0240E189B647
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 15:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1A01F4169;
	Wed, 19 Feb 2025 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="In9leCpS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1451F37C3
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977683; cv=none; b=fLvedmR1inCsT/tKbWO6TY+pD00TXqNH4fuaiDvmKEzTeITCiS1nxe8a/swH8GU0dQGCqHHm3XnXw+Gvudvpl2lygLHI+IMlpovfmHhHjCBObt54e+5TxtoijBJxS31AqbZUlaEhyRd/MfgVxx2SIVRHXQG0UfCrTeVBB9CrMW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977683; c=relaxed/simple;
	bh=CWhvF8YXZYVZoVR8KZ0Oxyl6VsxbGwfTgoGIC/AEQm8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c5CbqCHSQ25yVv4R5PfvUxGGRnWnrcrRGMTM5Dpgk2u95NxM33C5l1292KG774e3b584qsclEf+n91ZuzGNCzG4hmLAKO+wpVtPX6X3gz5LApB5+7vks9jFn8p1fOktxW87WVIx2OYsy8KU+uN2MBgDdLPbtMsUslF/KfJNYdwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=In9leCpS; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-855757f19faso144644939f.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 07:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739977680; x=1740582480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mG+31dwMbvcePus5JkBpwFAgEGT0xuWS6fReUxlox5U=;
        b=In9leCpSRowNUE+9Z9WXN7Dqd4QYsfJf9jlWUnbNjmdFEeAbEQkbxoVt9UMlqc1u6X
         3pLvqwTQMg+6USWmJIc1/11L160Lc2korh90PeyBSUh4CHHJQa+wx4wry/TKeo7akl4S
         KrYUdv/hgJPwirm9w8lzPM6X3DWb6KI+jQskZd5f6OiLXpc10h79fPIv9qcJj9M7tAHX
         5TPKsdlsjBWImnAAgsn5SwQmHmiivbL/DkIhbWQstaC8JmJS2TtzRTVdDJEHN/0/LPXR
         bkUsWwPqK0vXQSn75aV0NGJFxqpOcWg01OsrgVbe7rR6ZnV2otc6kUe9ALRfOVRWRzF7
         jkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739977680; x=1740582480;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mG+31dwMbvcePus5JkBpwFAgEGT0xuWS6fReUxlox5U=;
        b=sTsD4n9f2AM4TORnRzYsojzdV+Djv1G8PVsu7yVzfrsv9CuLtxOrqIHiztyqcTEiQr
         bB65+t98gPHX9A5h2oRUXWY4JE1AV93mMAD32gsK2JVI2k4BYrZTjEHLtg2nyLe9EPIr
         wPlE65M/OEOVFPbRpKU35wY/Wx1gt542fQp8WTEFu6DoAhJP0xgD0yBvSke+NswtWXmf
         SvPbRQN9qi11x67Q0PnzZB3TT8VWxpFOvLm0po8ga9Zk3HQuAsHZUkhMwUr/R+knO7BY
         caT3w729m2gsyT9cc+yjKBbDSQceaah43eTB21N5Tl9PfcnZSOPcd0yzeP4nx+POdMLy
         oqag==
X-Gm-Message-State: AOJu0YzgD7Pfv7JU30h+fVbP/GLMCJ8B66zs+9rM2QQ+tmEyXZUTPAid
	z4bJIhfkmiUI4Q2X1Xwlkp+fgn9vIQ9z4Tho/5ANSrTrT42ZEBPHemN45WsvEOUnR6FMpSbw7Jb
	b
X-Gm-Gg: ASbGncub7acG2WX+laNccN6w7DkGYbCnyefP+SeUwEiYkm5udUtmhKk43oyKzW5FvP1
	lrCFBJlS/V7sAJqiAhxnd+Kv5Xd5mNoCs7btsDZD20pyOsz+19hcswUJWZ8kEDgpVM+cMPXWaJi
	z+rLPSVJPFH5EW7gbklh8LWoKLcPLFMqtdvofLKddSDC+bU4vBczOWZYQ0xvYY9jAwlFUfWtXv8
	0WBfPUm29Izk5zsbfG6OJ7rNq9m/kXcruqOfTcRl8+fCok396zbNjx48hJXtNiS7K4MNp6yYYLC
	RKkXog==
X-Google-Smtp-Source: AGHT+IEv10mfqy18vMbSnh+HP6bdBtIl63cl7VY++iuKqRtkvq1Dh7TXlgDqVIuJ/Mft37qpPQczAQ==
X-Received: by 2002:a05:6e02:338f:b0:3d0:bd5:b863 with SMTP id e9e14a558f8ab-3d280951539mr173280855ab.20.1739977679978;
        Wed, 19 Feb 2025 07:07:59 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2af7f8371sm6678025ab.0.2025.02.19.07.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:07:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: kernel test robot <lkp@intel.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>
In-Reply-To: <fbf16279dd73fa4c6df048168728355636ba5f53.1739959771.git.asml.silence@gmail.com>
References: <fbf16279dd73fa4c6df048168728355636ba5f53.1739959771.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix leaks on failed registration
Message-Id: <173997767849.1535694.8872603541360388231.b4-ty@kernel.dk>
Date: Wed, 19 Feb 2025 08:07:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 19 Feb 2025 10:09:54 +0000, Pavel Begunkov wrote:
> If we try to register a device-less interface like veth,
> io_register_zcrx_ifq() will leak struct io_zcrx_ifq with a bunch of
> resources attached to it. Fix that.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix leaks on failed registration
      commit: f6977b06c598eab1db7416476452cf260208dbb0

Best regards,
-- 
Jens Axboe




