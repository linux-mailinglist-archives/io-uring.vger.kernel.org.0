Return-Path: <io-uring+bounces-1735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 493518BB708
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 00:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 063FC281700
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 22:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6A659B71;
	Fri,  3 May 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hAvg8dOM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CFF4CDE0
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714774683; cv=none; b=qrso/R2xUucDFEYUu5L/yk4CwjQURmnV7Bf9QzUDZ0nGAilj0YyO7acekZZg5stv9e11PljEJ0yEDxfISQe0SK0e1Zb6YqmvQLjLEWnRmub0kpjJgDmREJ4KqWCz6gjJ957SKueD2/SXk3JIUEFRLlEJGlbii6unw9Z1kn9Mk0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714774683; c=relaxed/simple;
	bh=V6zWzKj/427njmQMyT2B+Max6dUdeFOYQ41KuAckcVU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AkTL82bD8FjW9WQvv1YLQP1aZYnqT6UOn4CMaDU95xwAXFUUVkXoBi5XwC560kx0caP+qK+zYDGIge13obd6qnTYfvoVwj3w96KqmPSKj7l3L9lbNPpBe5qT+4SmfI+GaLFm6E+0A+XQQHSW+Ufpkq1LmwEJmOKbo+88sA3lnXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hAvg8dOM; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so61001a91.0
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 15:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714774680; x=1715379480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3NYX4GsJ5YM7t3DL8s+BT2aWbzp+O4eF+uLxtj1zihc=;
        b=hAvg8dOMHkZdNIbX0PgKUtbHLEP5wxvTpybalTV/Y6Z4cHUiZgObZnSkvOd92TnZy/
         JsR+Vmn3WOtpxWRqedZ8jzOda40Z4j+erY2Ql3X9Rh77FigeuIhvi8c35MUKMYJ/RgN2
         9l7EtmofVFc4fx3HOolrSHhqmV7mA9gaerD8Xy4r6DpVw9Cu3T+k6RJq2ZfbcsIuch1p
         KChRwZlTxj/n1ZBCsLC8+2gdEwNwfdl3w/onCG8WQBmovg+52GvTRh07UUajusPyIGAk
         gw3E1Pb9GJF1yiZO1E5ntRhaHMwd6/bwwzDjWDkv2d/tuN1nbtpqzSlfanuuYP5AdJfZ
         Cyww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714774680; x=1715379480;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NYX4GsJ5YM7t3DL8s+BT2aWbzp+O4eF+uLxtj1zihc=;
        b=Cja1hNmnaoJC5SWAKtzKyIvP6jH9Hw9Yx78RZ2SgJ6s/dU1ek34iwt8npRwHD7m/0t
         RDmAwTbk4o9qLbNXh8Zvkh8glMLUKGwQR/7yo76FaKP5NN2sydU1ZlzL0UQTan2MgShG
         n9HA7ucaYZdVlneYTD1NVjI9vksKsDqyEMzmKBLxMe/xTNciqDpZqk8piPLGkD7JcKmA
         Jt7fkHbcbJ4h93vCaOr9BlO3Os7cT29x4t/csGJL+0qYUQHWJGCP66L+LUpcHMwMzynR
         9AZAITSi2Q2xNC3S3K75NNUmcMsVk7u9dq/K57cneDVvtprped3WaGMGCJr7V+zWpRd9
         toFw==
X-Gm-Message-State: AOJu0Yx8oXiThHMSlf6TU3QM6ZX1FxRCrIM25aYr9CQ1FjMVEOffhZDq
	ideLG6/HBFgehBS4VPFVu+ihQ+PO/bptvz0EFLzc0fQuA9YpRJYolCavv0OcDiG2L8ldAJdozr4
	B
X-Google-Smtp-Source: AGHT+IHWsC2Y0DZE84bwe5sEUEoQzJ8b5qFw1kCzroIw1XIjdLY9c3q5qo0fXtgGbffMsMomdh/ntQ==
X-Received: by 2002:a17:902:d4c7:b0:1e5:1138:e28e with SMTP id o7-20020a170902d4c700b001e51138e28emr4500706plg.3.1714774679930;
        Fri, 03 May 2024 15:17:59 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b001eab3ba8ccfsm3746144plb.285.2024.05.03.15.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 15:17:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <x49bk5mehci.fsf@segfault.usersys.redhat.com>
References: <x49bk5mehci.fsf@segfault.usersys.redhat.com>
Subject: Re: [patch liburing v2] man: fix IORING_REGISTER_RING_FDS docs
Message-Id: <171477467905.63455.11570331658703910707.b4-ty@kernel.dk>
Date: Fri, 03 May 2024 16:17:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 03 May 2024 17:05:49 -0400, Jeff Moyer wrote:
> The documentation for the 'arg' parameter is incorrect.  Fix it.
> 
> 

Applied, thanks!

[1/1] man: fix IORING_REGISTER_RING_FDS docs
      commit: eb267a661a1636e69969d210654d90513fe81c2f

Best regards,
-- 
Jens Axboe




