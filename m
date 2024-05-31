Return-Path: <io-uring+bounces-2048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 658588D6C8B
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 00:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4A2EB235AB
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 22:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66FD81AA5;
	Fri, 31 May 2024 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uxmy/b8c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F32811F7
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 22:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717195143; cv=none; b=lV3prfjW94uJMDk2i9gBBQe5ONFYod4tdJn3b5sTpo95jjOkeLLL7PlB2eLmbuUtdf91lReu5lOW7TaKgzL62LZcbOg6SjH0KmWTTgPowckWHup/9506ETnmopjD+w72wybwquPjFYLKps4vsg1CUDC471E3VgvxzuwpD1JOdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717195143; c=relaxed/simple;
	bh=Gp+h7gJkzpSI2Ks2ESsp7zWXSM554sqxJCyQkREhxQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=huTgmA39thyzK/An2stGQV5lYs6yp4KiGCgI4I1ZrD23h6GUDW8hHxyncob7f+R8P2DzSOegTmkQcTEYMn2pq1osvpEK+KNnni3Wt0GTtTewgIKqVVMwVGFmltsihwWwa9EPmw7q2wvhkjTgWkx99BfxEFdS1LnIdZBi/dbeaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uxmy/b8c; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-6c82c37cd6bso1046a12.0
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717195141; x=1717799941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g8nnZQckDFTpAqP6/vrgwCFU1ySyY0/8E9SletvRuDs=;
        b=uxmy/b8cOBXsjLH1mADu4lcY0VMw72Eqk3SWGLoJJcjvRsrkUTTnXbBIMGaFjizak5
         u/ZI7Og0eJR4XhJaM3DLhtIESYYHEgbgcWVwC+5MeS35k9bmvY+1lbjpss/dM7DiR/yO
         xrGQ6OMsLckNQBm4Rl+V/ZkBO+3aFIIJb2vT2ljXWnXTM0fh/KAG5x3Qph4pkdWFEwMA
         CwUIGZ/ExqASl1WrN1wLvY0bC7OaVYNYhCG8PsN2w4CBCJae+m4OgglAsUnPTenEsBVf
         wm0ssKUGN+0A5AK5zRR/xgO+MxLDRBZRhaO4pZgjUq0YlXOY3C4Faptga4LQHGnxj25V
         FYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717195141; x=1717799941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8nnZQckDFTpAqP6/vrgwCFU1ySyY0/8E9SletvRuDs=;
        b=w+yGOzKQHCrxnGNLpr0oNl5bapG10YBqtKy9r5OGsJURnRCjGyGI5p36vsUJdbxAsC
         9PvXzYeqZy63PkPpRmuWQzkL4/GTy6reWdRVJ6DglfQ2Dnb5FAeKGFxrHLVaAk2GlpLU
         Rg0cpdsSg7duxoME42Ktqs0T00ERYvWiU/4ziDLrYWCOyukp5u5ca3PzAcu+I3d8pEkT
         fi1xALAncsxGtRTHz8JSbfW65Q+LjCYSmYC59MNBjIXhjsW2m43cIKX6aMSrWP94MrT+
         mPedA0Pg6ULAXOIyaesknCr7P5AbtQJK45+0aneFV8jd2KdCA3ngBcA4ixMQZcs1qEKX
         ivWw==
X-Gm-Message-State: AOJu0YxM6ri2VXipMht5rv6HCSGT1zXeJ/gIBIfSeoo8YVUYG6qfiKJ5
	vRL55dxtcjBP0AUvMp80SJOQwM4F1UEwmbWq1d4MkO4sYS0qtVHc5MZgjotmUJaqkm1lnpSoQ+O
	i
X-Google-Smtp-Source: AGHT+IErCTWIgRrOwDAxiXZmXG57PmA4Kh53yAxoT6+GSKLmTikBfUD2WSXx5t0QbJRU5qjmn01P2g==
X-Received: by 2002:a17:902:ea06:b0:1f2:f9b9:8796 with SMTP id d9443c01a7336-1f636fd28c3mr34212785ad.2.1717195141412;
        Fri, 31 May 2024 15:39:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63241efabsm21499865ad.304.2024.05.31.15.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 15:39:00 -0700 (PDT)
Message-ID: <5985bb45-940f-48d2-b678-96c106655e53@kernel.dk>
Date: Fri, 31 May 2024 16:38:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] net: Split a __sys_bind helper for io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240531211211.12628-1-krisman@suse.de>
 <20240531211211.12628-3-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240531211211.12628-3-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 3:12 PM, Gabriel Krisman Bertazi wrote:
> io_uring holds a reference to the file and maintains a
> sockaddr_storage address.  Similarly to what was done to
> __sys_connect_file, split an internal helper for __sys_bind in
> preparation to supporting an io_uring bind command.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



