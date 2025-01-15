Return-Path: <io-uring+bounces-5881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E07A127E7
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 258C53A73A6
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E756124A7F5;
	Wed, 15 Jan 2025 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f1qgz8EE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB5420326
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736956460; cv=none; b=MToaPkVncV/2hRAKB5QzuGUU08yQnGo5gkn7Qeh6lz3eTzU/cEocsVO45BLX8hvToRMNuuOiGQJDTVx3j5eH1vRquxWUzYHQlAayFL0yqqhtDyoatjl4+j9iqIoPVEcI9pfUV37YUogOb1X1HlbwX0dVCVIQwwcSZnunm99xChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736956460; c=relaxed/simple;
	bh=Uz8uw7yU/bdsDL4dA+w6c9foWZ6dI02t2aOM13+1dDc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ScLhbF34um/HfPIzIgpf1i/4Mubm74GJfEnmEuNVWL6LLtjhsIZR506Rn8sBvxJCD6NGEPVGd9OtkRM/W0b3K7HTxmT6EgpJbuZKNlHaiZFXYv2aMTWo2lIs6VgAI0+RNgnHis6/zYQiL3UKy20MZJE1saJSF9X+RwGYeYHjjv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f1qgz8EE; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844e61f3902so528044439f.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736956456; x=1737561256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7H6rlQEX39eVe9OhEuyYtZySzmMxO5+PedXHOPYTg4=;
        b=f1qgz8EEDNrghG2MgcLcdav8kxB0E5k4btQUQXee72nnG7aFdTuaDTMW0MGhObpVoy
         R99Mb/rBtkUiBPWQQIYfY/xf//E6iaFGbNDgknsgn8fvhP0OkxZ7u3q/MCRbdAZF8rds
         PAWNv8GmWU7VZxrF/Hhm8sqBNa3f4abyvj5WP90iszH64llL2hcHl/euZkvx87GeIltJ
         RIdY4KRD/CapljH8w2YznCZcpnn0SPAmYJGE+dQFJoZ//Gf52vRj6X1gDVFHO2rPlvuQ
         1t+5dX88zlhkoad+3E8ccoxSmvsiUX/92HQPyIrGxS5fmwmUa6B5C0wKsM+61mDi8GqO
         ZLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736956456; x=1737561256;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7H6rlQEX39eVe9OhEuyYtZySzmMxO5+PedXHOPYTg4=;
        b=dtOpMyr//t4lnVznH1JdhIBJMyU5zuGQAuh+ujA4NYLVmavZ9XX5nVC1QlvCogSOaX
         NfSzU8xq8Tin7HzjoBOqI74TAO9ke95+Q8+1chqVgzh8BqyzfvIq74VSJNbpoW5WcduO
         z46oXHBBlzUG8HA304K/VAiW49vgH4/eKhT4RwSGD04/94E64fDBdfl9WtEXzAK/uPrY
         KaQRZowHKTOWDi6wDgd5nxpwI0uBiY2TnqG2n+xHHkjsVAROrIbTdyylIF9AxFcnApUs
         +0lY3N+j5LVOScc75tVHm6aT6TJU6HUi0FCu7qJztg1F5XvfAni0EGbGiegVbQE5KPjq
         E2pA==
X-Gm-Message-State: AOJu0Yx7Jy5Qnm9GQcG9Ji2Lqpo5zenhVhPVrZyqIwTktNE+n3VvzyBq
	BKwZLHvno/Fw6RaXCHXl7Zt9G2+ub9oQbfQWwuAhimztcUB8mmX+l9Ouo7kofO9no3JDqt/YwyV
	9
X-Gm-Gg: ASbGnctTjaoQPqMwOvdvmC1D0m/0hOGpRxWGy6GLS+Y0n5hOoaQiDTbvcDis6WkRwsE
	WL1Ow/9pLoBuCu+NsFA2Sq73VymLcFqlR5KycDOi66OTkRMXC8CJJxG9nbjgW073jxqQlaBb3fu
	xz4Qy9T6WTUmWty0jDV61d0gRRuHbPzkb3BS/87SRXzelM3wYjIHX24m0QcYTXWj32eQP1XLkAF
	K6jIGb/q6xA+BzZlv5KiG1aqqqPNWByW9PABQsTt2U7ayw=
X-Google-Smtp-Source: AGHT+IHWwj1Zm/Dn9Aaf+jrSr64ADHAytK+3NMcX6HhIkLeoIyaFlDAYPvEralbU5G4fzYMXEzj+ig==
X-Received: by 2002:a05:6602:3a09:b0:841:984b:47d2 with SMTP id ca18e2360f4ac-84ce01a2516mr2954840739f.14.1736956455730;
        Wed, 15 Jan 2025 07:54:15 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b61322csm4158781173.57.2025.01.15.07.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 07:54:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8a88dd6e4ed8e6c00c6552af0c20c9de02e458de.1736955455.git.asml.silence@gmail.com>
References: <8a88dd6e4ed8e6c00c6552af0c20c9de02e458de.1736955455.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: reuse io_should_terminate_tw() for cmds
Message-Id: <173695645463.21323.8158396839418525853.b4-ty@kernel.dk>
Date: Wed, 15 Jan 2025 08:54:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 15 Jan 2025 15:40:48 +0000, Pavel Begunkov wrote:
> io_uring_cmd_work() rolled a hard coded version of
> io_should_terminate_tw() to avoid conflicts, but now it's time to
> converge them.
> 
> 

Applied, thanks!

[1/1] io_uring: reuse io_should_terminate_tw() for cmds
      (no commit info)

Best regards,
-- 
Jens Axboe




