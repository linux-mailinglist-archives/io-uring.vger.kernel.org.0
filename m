Return-Path: <io-uring+bounces-818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD1587013A
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 13:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBA951F22DFB
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 12:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70CC3D0A9;
	Mon,  4 Mar 2024 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LHCMDeEZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2165B3CF59
	for <io-uring@vger.kernel.org>; Mon,  4 Mar 2024 12:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709555407; cv=none; b=TnuVGC2RqWf8Zl+CcKAB2QEdQsO7zcVSYDwxZAhTEWyjoTT75NyHJnwHIg2otPyNp/KiGn695ItCpgZiDO5rvettAb2Ll1hpKF234Jgv+3t1WUyMb93Nv7qW5ykR9UeoEOKvodWsXpOeRZ9CGDmhmTuP1I7y3GfFbVyS/sms+Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709555407; c=relaxed/simple;
	bh=tos/XE8nUrwUjUI9a49m2+on1GSRTbO2ig6VgPrrMTo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nc7Cm4CX/1hZnS89onmETrHxd9LFpJeK8k9cSaMkXWwiPUBQ8VKiUn0aLpXLNk35mgoFqvEbpYCPECaPeVUt3TS+/90DEdhJ1FwpbBX1ruPCgNpRya4zWhEenTCHhh7m5MOyvxYuctAL4m5Uk2cRDimfBnrIR8oZ8CKyyNQf19c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LHCMDeEZ; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-607e385a927so1661807b3.0
        for <io-uring@vger.kernel.org>; Mon, 04 Mar 2024 04:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709555402; x=1710160202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pbqD3l9Q7vGB2r5aukGuoFJbfnAsdpKwNpBpYv+KazE=;
        b=LHCMDeEZNtPjuoU0wQcb5xKvGnQjjOOzT7UuWXUM9vtcw5pwuXdQZaScrb4MgYrjOj
         wAd92s63JmAnwPqFj86GgKsV3/LaxkOarOwnb1oEwLY3O70Z2rscSRHqJktkzHOnw0jQ
         ijHtn4PfFROOyCrnSYtuo3G3A0QONtKszNmBSYIMhsTFw4nuBombIAIV+z5+YVykM3bH
         EoIv5B65U1Qk4OVx5U9bJBdw3O/O+YnATscYNduY50hZ35aXG/po37SIPVRkaDblB0cg
         Cty9YDe/8K9Bjtt4nz7slrQFCrzHgK4c+w/4zGo9p5VyBSyaC5Yt1aFcaKiL86w8WO3n
         aScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709555402; x=1710160202;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbqD3l9Q7vGB2r5aukGuoFJbfnAsdpKwNpBpYv+KazE=;
        b=nRgXEh5nxzkQRBx9fPBXepWOb2Lkp0/sk8ygK52+fWTNQs6SpBe7/X/FH69tN80K0U
         MMn0RBbRs2K20g6fC/VlPbpwaU+fRp6kJZQD8ew/jPBcWnMSekrHf0tVLTvIee2NKpVP
         GMs3EY9y+7yw0CxtuuwxMLXsVcRj7JEBhequ/muD909dagzgHPqOZHKHkY5ZrqrvY46/
         W5NftfuhM54yywFeIM/F1Ss2CevAQF+QPVP9BQWE3WXvfSYQQfwHl8INwnt0Ovf8xk70
         XTV+K8lc5hOjrVSZh523BC3RVosIhD0BmGN5Ea37OmVcp82lTqgxDOtSUQucUXZDPiqG
         7m9A==
X-Gm-Message-State: AOJu0Yy/ULQSFiu79CekziQAlrcAbrM45qVmZvna63wklE5/LEBVMMse
	NaR8PkSeIHdxG0mhKIkbagFkm8D2548+UV6colUE7P+8zxWovegZ5OC4AXdvz8A=
X-Google-Smtp-Source: AGHT+IGXTnN975WiJc+wzrB7Rc7XbSum+tMWUX6qlrYcA3V/zpd4T9FQc3/11cpsJqIugtr4EhXfCw==
X-Received: by 2002:a81:aa53:0:b0:608:ce6a:935c with SMTP id z19-20020a81aa53000000b00608ce6a935cmr6291535ywk.5.1709555400452;
        Mon, 04 Mar 2024 04:30:00 -0800 (PST)
Received: from [127.0.0.1] (075-114-046-194.biz.spectrum.com. [75.114.46.194])
        by smtp.gmail.com with ESMTPSA id d202-20020a0ddbd3000000b006088d18ade5sm2598820ywe.50.2024.03.04.04.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 04:29:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dc574ee0e7eebe7deb691ddb18b9643495ea8331.1709510250.git.asml.silence@gmail.com>
References: <dc574ee0e7eebe7deb691ddb18b9643495ea8331.1709510250.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing] man/io_uring_setup.2: document
 IORING_SETUP_NO_SQARRAY
Message-Id: <170955539951.273219.14551779323824740129.b4-ty@kernel.dk>
Date: Mon, 04 Mar 2024 05:29:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Sun, 03 Mar 2024 23:59:17 +0000, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] man/io_uring_setup.2: document IORING_SETUP_NO_SQARRAY
      commit: 7dccf035cbca029f2ca863aaa074aa75a9d61fec

Best regards,
-- 
Jens Axboe




