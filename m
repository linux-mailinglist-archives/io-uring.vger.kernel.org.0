Return-Path: <io-uring+bounces-6474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EC9A36F06
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 16:15:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3BA417048F
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 15:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63091B532F;
	Sat, 15 Feb 2025 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CjSxOZ7w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355E42AA5
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739632550; cv=none; b=P0B3eVGg1m/Z2D4nCJKcsZ0IP6qirwFDc/rShUHRxu6q62C3+sMFIhpo4gjHLbZ6kw48/LBD0EHDCPQwgFGbQe8S4SBwCgcLy1ASsQKmmDm5eO+l7Og3KnbQwBU8sP64eA3Rcm+IE7KI5tdSsjXuJTKiiOOJsCcix/bpgHRkXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739632550; c=relaxed/simple;
	bh=e02FizhTrRfNRTaCqoTcuWaLP0cn3VUJ+F1CaA4gDJs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BCktpaX6/MNLjgAWh+uLPqVVo4qPriFTH66Sgii9PwGdcS78xmAcL2Sbdh8lOHyJ+U919CqKdnl85ryyR86frQ3xJlbUA+IlP9iwntQO52OIATI0QANdh3b7JAJ13LxTMYCFYSL8Scx+7+/HRZ8FUkJj7bBLDxN3hsqLQFmi/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CjSxOZ7w; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d18f97e98aso20526445ab.3
        for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 07:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739632545; x=1740237345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+1BXq6qo8PpeKvBLCDO/mqozggWmOh5eB8KIhtyX/GA=;
        b=CjSxOZ7wWqQNzYiLh8DneWczghqHNAAT7WChXOIfYbOuChamdZwfaSUwfF8yPbVSdO
         S/TBvlfmlZYUiEBgyPxdqUfXjc8+6O4+6Ad0DEDUtUSB1oQ5CBf9CyZgXCmtitMFIbuY
         /0bLmx6p+uKnrm3u0OJ9rW7k/XoyUVssFo1xeCbXl9Bf2GEEX8ZF8XN+3hNF9UkIENH9
         kVx8rRppXtpY5OK/MtsfrkERna6cwndKOON1F7yFXkfxMhtfz/MPYvwJfnmAHVzz4j1e
         7eun9vuPrafZrNhu83wKKOM3yGD7BjIspbb4wIYyrHcABqOmh/PdoOG9RMBThQ8F4qrl
         o2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739632545; x=1740237345;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1BXq6qo8PpeKvBLCDO/mqozggWmOh5eB8KIhtyX/GA=;
        b=VHSAA2YBwKaqqUwLA/oHPDYyDvAC4c+7C0cZzSDMqNzup8LNaik/DMfhYMU2mXjlVS
         8AiFl3B5seLPXYp3rAFPgV8r1Nb4RJoIGkp6rJRdVrzBxW2lsXjP/mHIp6cw6nGSzR1W
         lYY+H11O3BwjqR8T6PDBB6w3oEZIaI/upW8o5Wfy1tiaWRY/dsfR6mAYfSw02uGi16UK
         CEsW2NDHnsQekgOvLwR+v4r+L/098JGI2npqa+S0ETFi60d1LiVdqNFmCHF7JtLh38r1
         yXKtO+EzfspW3kA54PpSOSAoqr1Cj8CYQQ8yUbbBbGx+qXyWNZgE+S4vJN/7OQWGub/c
         +gGA==
X-Gm-Message-State: AOJu0Yy8bCGNVrVmieQR5XGqeZagJ70e6Do2PkSIy1x3AQY354H+kw5y
	TAUz78lqfSG9PX3o6AjGQJaZxJtSf+ZzlS9qaodFHmUA7frUJGHC/90BvB2ttMCEcautzqHU/nr
	/
X-Gm-Gg: ASbGncuX+CVuRwFVCT2W5vDCWKuYawCjW+ua7oJv4hQUKuxY0YUgpX5WqYcGvdRxPj9
	k29hmxDiBjnJ9bn2VOmP5dAQrNGaWiWBcvvtV5fIpxf6VqQtSAy1uercOOAMY+SViEQQfuCrrUE
	iNtqMXkp51EY7pFAq78ORmZEvPr8GHEprfOkPRRmjBUrB4Yg8C+j3489HOB++YAThfhotRZ3A6z
	VJiP5eTns6WyQt7xIucY5O8x47IyU2VZ20jCcrXVyGYzlkxLYLa8ZxHSPbTM53iZcjeYW3oWHTN
	O9gzWwE=
X-Google-Smtp-Source: AGHT+IETlhvS7ZzmUT6JKMpzo7L4pu4timMiJx05z4O/3acRUmWaW6C/nN+LSKeyFks14U2MCb8TgA==
X-Received: by 2002:a05:6e02:3981:b0:3cf:b26f:ff7c with SMTP id e9e14a558f8ab-3d28076cc24mr27518645ab.5.1739632545438;
        Sat, 15 Feb 2025 07:15:45 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9c5a2csm11657185ab.20.2025.02.15.07.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 07:15:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com>
References: <7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: prevent opcode speculation
Message-Id: <173963254457.12458.1902250086361474768.b4-ty@kernel.dk>
Date: Sat, 15 Feb 2025 08:15:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 14 Feb 2025 22:48:15 +0000, Pavel Begunkov wrote:
> sqe->opcode is used for different tables, make sure we santitise it
> against speculations.
> 
> 

Applied, thanks!

[1/1] io_uring: prevent opcode speculation
      commit: 1e988c3fe1264708f4f92109203ac5b1d65de50b

Best regards,
-- 
Jens Axboe




