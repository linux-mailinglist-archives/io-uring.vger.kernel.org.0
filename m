Return-Path: <io-uring+bounces-7254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A07E3A723F0
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 23:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2B0C7A68EB
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 22:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA05E1B0437;
	Wed, 26 Mar 2025 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ga1f25x3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E7C25FA2B
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743028151; cv=none; b=AT8wudunh9DDKR7c9zmUDytQ2rHVidc6kmvTGInRArihwOa4b5d82q9/cssi9XopJE3liiQ9tPw1DN6lHFCS93+zOsxSmrioGIGfKV+Y/qcWcDv4GuRbIQGT2oBydAfqgX3P8MAfrAMDzyFtN4qQb7Na31zVnp68J60+7bxQ2o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743028151; c=relaxed/simple;
	bh=LQhJMiQHwJGjLPoxjYftfgktNNMFqBVHkFMCPRkqA44=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aci6BJXzgvMlGVMsOjHHh9UZHzptDrx2V7OZBjlnA0uabvd+Lyi+pqX952TZH25KcA9jWC9lD2nDhC3e0SU8ShYitcXlOyF/1Si+8vqfH1iP7QI5wf3wQY9nRferhQ/zWxPOMyPdCrRdFp+px3NzOYTMkUZqGGrLpJtrZcOfT+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ga1f25x3; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so50654566b.0
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 15:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743028148; x=1743632948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zAZUeFZzjXnFhP8m5JBmOfxeDCitgd0x8BIpwgzeSF8=;
        b=Ga1f25x3n2LzYOBg3QQv66XWjCglL6zQ8yg0Hurkz0CFjhH5tG8cEG9bsvtV1ZKY+L
         2wza3kxruloNju1pyyzrC2bDeBxp6tfCA9SaxKlHMzRXJDyX9TlOowynIMBQUiiXSeHy
         4nsPQga+sXRtgV0AywQb9XgdaMhQyd9u/OrdO4WYD40xuiPrP2UnuS0g/Py0oHs0SBLo
         NKDs6pFB9l2nGLnuuXhVt3J7y+7HRcp/74bu3pqqATdjHBphHdQ2HcNwGtC2K+O+aU2J
         JZvRDTUFJvnaTGYG2TjGKMzAuXquHpQC7yPGnoQja4lj0Fu4mld0Why/pudDpEZYYEpg
         eEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743028148; x=1743632948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAZUeFZzjXnFhP8m5JBmOfxeDCitgd0x8BIpwgzeSF8=;
        b=PTPb0N8dud2GAayVDZby2sKEgPKrL0s2tfakkU7EV3URsmpFVrCYxdBsyv+2OLFQ+Q
         LqKGt34h8vgBZTZeF4YQPz1m67NOsOZL05jYRERJOrAFwNiv4ko0waq1rACKaHuaxc7S
         banvDOyRGufQaf7Lutx6Oma2Dwbejf/kplZM0VHTXJWNzfxLOeKzmxHCI9p4aMo0PS28
         MxBjSgmVVFzF01O0dgimUM8F87O+XIXce1l5Uhb5+7a/+lsU0vGySzSzfMqAvXXUSAB4
         t1QGXzJLmrlLjIyQNjXZI6GOuQ2/pSB5sioal0flLd9P8eHKRvi+ijdBLpUdmlsrfs71
         LhEA==
X-Gm-Message-State: AOJu0YxoWepSxzW7TNMMwpfQHYKwwibrJliwDZbP8vUf8DDaoYjUGwiu
	VErSQzgEFRND1/CqSiugwuRlZy3wGvnsnOa8xnYhUX9zkdLHyJOKDp9+0g==
X-Gm-Gg: ASbGnctl0seX+juwFkzIVeCFC+KYIx1Z5iSATG7N7jnevFUxzgAFjDRMMXEvGUEm7pi
	li9uhmnMTJOMd+GrGQhX4KLlsskAU3EXPreahmPTYI3X5gHSvHw0c5l+XcjjIeX1c2Y3l/azgoi
	9xQkNTh9WTc8BJyyeJd8b0Iu6F+TW8sWw6SxjFPLCFiTFNHIQqiCJRsw7M2PV9QSs2HbhOPQkTf
	v0SXNW6eEb5T6JVUu3XGkTx92K4lLjXR/kfj3EmFUjkCgcJu9mPoIKEdmdWG8EhRwjOj2Uhvjfa
	FNTrQjc8F55h+kkarO3X7Y393YErxGiIFe6eLQa7cPkud7FDlpuhvQ==
X-Google-Smtp-Source: AGHT+IFWkKr0r0Nt+W/9Z1NF/nmPFpDVAZlH0ACCPJQtc6iit6hMGxUWBwuvMb3dxiSmFh/okwO9ow==
X-Received: by 2002:a17:906:6a0b:b0:abf:4bde:51b1 with SMTP id a640c23a62f3a-ac6faeaf93bmr84107766b.21.1743028147572;
        Wed, 26 Mar 2025 15:29:07 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.207])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efbe0356sm1125345966b.144.2025.03.26.15.29.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 15:29:06 -0700 (PDT)
Message-ID: <4cddc5aa-a5c6-43f6-9816-7f975b1e1d51@gmail.com>
Date: Wed, 26 Mar 2025 22:29:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/net: fix io_req_post_cqe abuse by send
 bundle
To: io-uring <io-uring@vger.kernel.org>
References: <3a6638b0f3567a00cfaabd80821fab3b60d49b36.1743027688.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3a6638b0f3567a00cfaabd80821fab3b60d49b36.1743027688.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 22:21, Pavel Begunkov wrote:
> [  114.987980][ T5313] WARNING: CPU: 6 PID: 5313 at io_uring/io_uring.c:872 io_req_post_cqe+0x12e/0x4f0
> [  114.991597][ T5313] RIP: 0010:io_req_post_cqe+0x12e/0x4f0
> [  115.001880][ T5313] Call Trace:
> [  115.002222][ T5313]  <TASK>
> [  115.007813][ T5313]  io_send+0x4fe/0x10f0
> [  115.009317][ T5313]  io_issue_sqe+0x1a6/0x1740
> [  115.012094][ T5313]  io_wq_submit_work+0x38b/0xed0
> [  115.013223][ T5313]  io_worker_handle_work+0x62a/0x1600
> [  115.013876][ T5313]  io_wq_worker+0x34f/0xdf0
> 
> As the comment states, io_req_post_cqe() should only be used by
> multishot requests, i.e. REQ_F_APOLL_MULTISHOT, which bundled sends are
> not. Add a flag signifying whether a request wants to post multiple
> CQEs. Eventually REQ_F_APOLL_MULTISHOT should imply the new flag, but
> that's left out for simplicity.

Needs v2

-- 
Pavel Begunkov


