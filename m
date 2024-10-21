Return-Path: <io-uring+bounces-3864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED4B9A6F77
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4FB31C22E00
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F96199239;
	Mon, 21 Oct 2024 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VXZs/X4+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3075B191F81
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528240; cv=none; b=nGpA12ouKujiE3hftmuDOCEIwFqeYe4civV14aLEWGpkNcfXBZ233X46E8aIdU8h78PeCiitJP9IWjBoxkK2l+lslYIoXjA+eVb6h7tR0i9yw+tuaoizxaMo+8eMLPZtQoRPTYrmx2X2ytFy25CGrG8kOOG5kRwH7hw3DXBqQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528240; c=relaxed/simple;
	bh=82EnS5fxs4HAEKp3RYPaUrmzu5xS+BPxemHrEA4kBsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6rcEKhgRRRpc2hdGWRyvmgbx0uKCIZ4qT76xiiBxa7hxRHnQ+ia4TJhyrjrusNsaXw3GYHrkIx7HZzgvH/oF0XFsT0abmqdLbtFuu+KHEoA5/NzMzw1N9iIDbK2HH8gR3kqmSa6/H/3/FBxr40b+1xvBJnI6rmJyjs3J6gMxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VXZs/X4+; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ac05206c9so99749939f.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 09:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729528238; x=1730133038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=VXZs/X4+8vEvpdozs53EEejC1t03PHtinbnvakquWQNBFsAylz0KWcUnIQCvOHmA0y
         nZxty8Gep6nR5InvsgFeC7dtqdu52LaIGo0yI3uK7ps/U/nabwubfQx0Cjprs8iJhTmF
         vHY8PC3J+ZpDfUm7lHlK2P4nvNIoK3KGeUfn0TNqdlrbcmpEbXvr3BUtVxI3EeF01b18
         t4HrtMcc6B6U5esxITHS+yXPz79aXNuONkC/PQaA3eLgwcypdE11tudSyg/qNzs8deZc
         TrnTcGkOhTl11bB+o6HGbNMGVjA00BMMWdYQfE0fyP4F/DlEigAPb5NhfJxWjwU/emuc
         HOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528238; x=1730133038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=bzJrFThA//+ZzcmeClKv/VL8fN5V8rfunct7BpKlJhKIfWJXro0NuvnowsfIyvuCkI
         atwXAbm9DGa1CrG96nR4MduHEZC1Urg3QxnHZfWXxUklXHeH4uJtlVZM3V+VETw9MVLt
         ll72BTafBi2TMbNnjlUEGciUhMMtJOaWMn2loH/cIgdWIEaE0eslhXXeBiTKIYPaQbLv
         ZW9BI83hhc9BtTuZ1v1x7zWsDZlg6RvVG8UGsEVaSFQ9GSsU4MosxD/KnHm1yPP8wOtN
         N7q5T1lhVqopfXLKF8kBqk5Hov9/fxdvMR6lQ9c0vIqqDLSvQWqqM5z6M2ad7cAZzmyZ
         Lb3w==
X-Forwarded-Encrypted: i=1; AJvYcCUSPX5RXj0d/YIOJGzdITuCFn8jRv9kPwk2N9K8NtkXv2tUxmSTrEDEGwgYi0xs72S4rS18XIBCwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwF1OZQV7e97k9XdjjF/jLC0rbRsat3uNhCJlTxi7RD1KSgSinN
	7PjFRoyO9Mycowo/VDOXBYWltNAPP3H+SAGdpSmpM4RiZK/Iapn5XdJ3HUcl1mE=
X-Google-Smtp-Source: AGHT+IFyzr5YupDPlvuIlhBH5/WK7kLbJsqNYWpaCmRhgQMF4ScdKqNoU25XKrBuyCpOWI64VfdesQ==
X-Received: by 2002:a05:6602:3410:b0:83a:a305:d9f3 with SMTP id ca18e2360f4ac-83aba645c6bmr109225139f.12.1729528238162;
        Mon, 21 Oct 2024 09:30:38 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a52fb45sm1090704173.6.2024.10.21.09.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:30:37 -0700 (PDT)
Message-ID: <cae0189d-fe75-4fd0-9b04-cb0bf1df4eed@kernel.dk>
Date: Mon, 21 Oct 2024 10:30:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-14-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-14-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

