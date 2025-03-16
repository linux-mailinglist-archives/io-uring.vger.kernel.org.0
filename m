Return-Path: <io-uring+bounces-7085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A8DA63474
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 08:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84D4B18905BF
	for <lists+io-uring@lfdr.de>; Sun, 16 Mar 2025 07:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F35517D346;
	Sun, 16 Mar 2025 07:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhLctQig"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729268BE5;
	Sun, 16 Mar 2025 07:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742109680; cv=none; b=FgTMsJB4Rziby0mfNxYOJpu2mP3ug74bGxRXM2kc82YJIPhU7ZX+W5ha7x0k31K8p6/XrwDn1IdhAMp3f5SEOBtLtWGjWZft97irTIte+de5ShEPWIN7qEtP/ZjuRb2EOZvhh00tLD1pQJlwH/r/fYIubVOEd7Guk4yybqbJN1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742109680; c=relaxed/simple;
	bh=fUEArptwHh7VCmWa8gbn8w3XfIUC92OgSip9sFYi8yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YoPjux5U4Ece13PhXNQ1HDzHEGftW+4LSVrsVUvOdP4DMXiEBdXqGoau+8ZK1DvjaQDwLc3uOOZaH2EobLWXYBXOObolkV7LnXLoGFNK5aRFddFRwG7PIvcm5CnUvJCdU7ixa5uae+tO0O/EDo1Yb82JDZPEyQBOonK5Pob116w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhLctQig; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-307325f2436so32901581fa.0;
        Sun, 16 Mar 2025 00:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742109676; x=1742714476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LJ0zj5HxkJGbMHm7slNEnKBoYGiI1e+MaByhDXOaeQk=;
        b=EhLctQigoPMeoWm2HhxK+mCl+Bx85f4s0gvrJNt5+2xmkfeh+5F7Y5jOs+Zmdqouxs
         cFFveKeVOmcVSHP89BJIm184yfL7wwzYaQBq9zjr3dxTUC42Xw5tMa9WuhU5SVGXeo+f
         eX85GI+hLmxXgmQi1j0yPT1J/EUIrgdzdxKrIYcoN/YiKdxek9u+ZRodoiGwxZUscVNJ
         8pfVjv8IKZCXt1PtJpP5RXfzEeybLdzSpM1aOH3daZMOhyYq6UUYMAHwK3MeTdIhW1c4
         kSL32xOFy9jD/SPG3jSgEFgTod1fhTyuERjtNecCFVXp/fOxuwFpVuyXTiWdwPAv4wni
         KHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742109676; x=1742714476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJ0zj5HxkJGbMHm7slNEnKBoYGiI1e+MaByhDXOaeQk=;
        b=A1jwpBAL/qVBqC7WwGA9tAWcU54cYQBBLSsbLKh5bbUSaqwzyUtN1+iln/rN8G9Dl9
         hpT+F+JD4hkiCceVpq1tBTVwTONq6Zu0/pAZOc+ZF+7BF/9SnO964VhucizT0ZFODaBp
         6Y1zrNfSvGj3ttfDxpsdJab2Hcfr//oKFN5ofYJw3fcB7ahiv7R6nYY5z/+X5T0z8Idj
         5zz/LYWEOKmhyc494wCgnm+E+CepjaSr7uTYYlS4++oUY4hlfoLcdKb0xs6ovX4JHfNM
         bJ4dxuokZvWz0Z51Y4N5mlJB0m/x9Kiu/rM161xC3/nqoKOfjYml8d2va0zYDLfU3fDj
         PjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx4aUY2Pc60dxdcHuRo8glzvUMdGjPXHnDOMl0KPlmij9y8vc9wuMkGcd0hKWb2yLjklBZ0E8KzuOgXEUk@vger.kernel.org, AJvYcCXpRu6PYVDEGiV1ehpkK4Gw6szOCRmUhCXwZeyv29dum4E/3GyAY4RDCNRU7JYmX40qyNzQ2w9jIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuQlDq/ySvQfeRfdtE4yf7lh3LO+nP6Cpae2cMnJuig6yKYGLk
	JHrGB3mR9xQ5pNQS7WBmbyMs4GbRjJ4JSBH4Nzdscj7NKdPUkhNH
X-Gm-Gg: ASbGncvIQMjNt8K3P7f1IpWqqF4ZTKCMHWqyktczngBjIymRNShRjG8o+Q9xiXnlJ5L
	yK2pbiztksF8bs358wdHQUyu/9crdcC/aLhGPq//qUDQeJ7mGeO+Ei+UBtSUaOwnavPtbI9I4qA
	jQKYpA3j+QixyE9j18JCeH9Kd90TDULPqP68cC4hrbQ99bfUPhsmuJ9JlZ1oM3KIWNQgvlGPrLV
	MIHiRiCuyJFQlVI5Op5T6FH7I/8VMrqRVPP6MO1IusghKyixL83pZ7VcH4UgQDWlj9RkeidYsSM
	ifroLE+GszE4G3Uil2qqFTVdqw39Bfg+aCwVCY4fQpJF2ZWHWl7pkrZYDiRNjUyC2H7MO5Tlyg=
	=
X-Google-Smtp-Source: AGHT+IHn9MwUdb3sdsaLO8cyH5ynJzEyV9o9UzTBCZN3+bOYadeH/xiMFDNPV3R8tbrI/nmNoQJ4kg==
X-Received: by 2002:a2e:a16d:0:b0:30b:efa5:69a8 with SMTP id 38308e7fff4ca-30c4a8f36damr26850671fa.36.1742109676247;
        Sun, 16 Mar 2025 00:21:16 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30c3f1da6desm11899121fa.94.2025.03.16.00.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Mar 2025 00:21:14 -0700 (PDT)
Message-ID: <3c8fbd0d-b361-4da5-86e5-9ee3b909382b@gmail.com>
Date: Sun, 16 Mar 2025 07:22:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/3] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250315172319.16770-1-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/25 17:23, Sidong Yang wrote:
> This patche series introduce io_uring_cmd_import_vec. With this function,
> Multiple fixed buffer could be used in uring cmd. It's vectored version
> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> for new api for encoded read/write in btrfs by using uring cmd.
> 
> There was approximately 10 percent of performance improvements through benchmark.
> The benchmark code is in
> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> 
> ./main -l
> Elapsed time: 0.598997 seconds
> ./main -l -f
> Elapsed time: 0.540332 seconds

It's probably precise, but it's usually hard to judge about
performance from such short runs. Mark, do we have some benchmark
for the io_uring cmd?

-- 
Pavel Begunkov


