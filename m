Return-Path: <io-uring+bounces-10717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AB70EC78014
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 09:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 841D54E81A8
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 08:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C97F33CEA1;
	Fri, 21 Nov 2025 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4s6vex3y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2002733D6C2
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763715250; cv=none; b=r35GBdi19OwynVi8H8zLwR35Ls0i0gz4RMKhMDg7IhQhkCWuTLKqBe8IZq80Z5e0nbk7LV9Sg8gq4TW5y/jN5hw5C2XYtRZXG5EUDuCsew4/RybyNaxYLfmYGnGD9/47FIVrpSg3/Wq6fsXHiI8pMZktHAxXOLi3Ftzum0kuyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763715250; c=relaxed/simple;
	bh=u/Xnrcvu7raz4zGpEQjS/K8p4RasVPBF3ZOLpuJkQA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tiRyGu1sj4hVUBsvJQDZGzHZiHE38FvMa53eNorczYuKgoILwCVmKbJ3y0NQJ8qYFaWldN4YCiIYX6KAaVGNHPArDgW4jzKoWpaP85Wp8uU1NUh8tZtPayal+q1gNTUSdHgS/UEqH7fv1sMUHgFtlQ1XQ8H5pngRQu0Xvhkf2d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4s6vex3y; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779a637712so11496535e9.1
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 00:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763715246; x=1764320046; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WkxFF7Y/C3Uyt6cbFd74k4ikA5f+omWOtrl9H5+zqwk=;
        b=4s6vex3yQm8X/jx5C486YFULn+zZIIfv6KGFv4uJhgSGIgJOj6Lu5ZDczWdko5Myae
         3XL5xWmt90q0ImiFqzzF2nig827GeUVNJ8Lov64iqO04xtmRZuq8OAs9ykLo9XT/tNAL
         CvlWA+zgc5HC4r7zqrOiry76zBdA5Voy4zKa8bXcTMHw9YCv4ve4WGRWWrKjhe6zYmzz
         8vF1Ui9K8hTWG1FcYKsjbbI9PL7vDMXmnkYkWzcuu/aw8w6jfaGr6AdZfye/KelcOUsQ
         Csh4W8f15JuYxey0PMc/5tsLLP4xyp6Kdj+0KbC+8yBGs8bUVE6Eoki3hyJNfQ8h259x
         pjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763715246; x=1764320046;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkxFF7Y/C3Uyt6cbFd74k4ikA5f+omWOtrl9H5+zqwk=;
        b=GuNgd1locUL5ptWpQUDbR3nkdp+epu6qdq1UnaflH+BDbxj0R7kK53311ZBMBfa6XL
         jwFQ9tjOz+YeV/sqWLKxBp81pvlWkjCmvHYvAbvuFdeQ4GlINgsRZqBQnukVglz1251D
         Nky6I3S3BZ1RPk+clW44rWYQ9gvmWeF3u9VuCE8ZQoNoqMGNNGsX/wWrWOL11ZAYvT7/
         lbSQPub5M+nHZTaZ479MaUr7XjMYrUJ6/Pxtb9wbDxYAAZ9QM3P5P6S44FGAjekJL9ER
         1RMcD1/mcYTKzEiNTn+ps90eUaKZVbVOg9kzz6Hu7m5pvy+hRvBXPqK4M/HMQ1ChARoA
         8HWw==
X-Gm-Message-State: AOJu0YynBEdfv5/NblMGzVaHwefHe8+zYa/Z//bvz4dpVX9Xxbs1fi7R
	OW+3EK32O1YQ8pQFr6DdtZ9ORmbphlYwsbecXVz2RMMh9QVvfh3V67g8VznKT8pqIDmf/2Y40Ox
	OBYlCU+37
X-Gm-Gg: ASbGncuwCX3Szu6DlI0pMndI6ON2rxXouFpdaKayh9zfNr7HV/SOFWhIrXyLdlJUVgy
	N7ZK/2led4hU97FgULrppO1f/llyNeYhu6hV8avWIh3OzNt/zT20jVjztmOPXvFq+TQbkM1vcIK
	0MB6WzpJr7IGFMf5KwJ3B/qZHLcJsbXi0GXxbxd5tdFB/PSgW8YjvJ0KCYPe0MOsjS7bI35kwPS
	wfMABAIva5NSJAkSkAc0RKVC/b5fEWr8LNml0cwvD2ir+aKDrob2D9uSCGJE9Bd8yJ+6gvIjNLa
	SV3UEZP90d4dnri7j5bOMohRU8NfjLY318aFs16efqtgBLKw5bZyvkYn6ut+v4eb45zEausNWPJ
	4yXWnn7R9e6HtWRcsP39z6zGjDrPlSTRFOwY8buREVc8ZIeQP38JjDVpNd8GdGOf1I63V7/EAbC
	WRWy1f61NAnNIBQLGZoLuhFL2ujFIeVbrLmbvMVgUPlw==
X-Google-Smtp-Source: AGHT+IGJqq3tUuZcU6vMFeb3X4CjpUNy1it4nIH32hp21zhEJLrYSmEZz3dUfkj0dhfu4o1iu4JcjQ==
X-Received: by 2002:a05:600c:1c88:b0:477:9cdb:e337 with SMTP id 5b1f17b1804b1-477c0165badmr17698595e9.7.1763715245969;
        Fri, 21 Nov 2025 00:54:05 -0800 (PST)
Received: from google.com ([2a00:79e0:288a:8:9025:43ee:a754:64f9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a974cdc8sm85901055e9.2.2025.11.21.00.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:54:05 -0800 (PST)
Date: Fri, 21 Nov 2025 09:53:59 +0100
From: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/cmd_net: fix wrong argument types for
 skb_queue_splice()
Message-ID: <aSAop5CDhDmh_0I-@google.com>
References: <2b6dacfa-5e44-49da-b81f-51710e2584cf@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b6dacfa-5e44-49da-b81f-51710e2584cf@kernel.dk>

On Thu, Nov 20, 2025 at 01:24:14PM -0700, Jens Axboe wrote:
> If timestamp retriving needs to be retried and the local list of
> SKB's already has entries, then it's spliced back into the socket
> queue. However, the arguments for the splice helper are transposed,
> causing exactly the wrong direction of splicing into the on-stack
> list. Fix that up.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-462435176@google.com>
> Fixes: 9e4ed359b8ef ("io_uring/netcmd: add tx timestamping cmd support")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> index 27a09aa4c9d0..3b75931bd569 100644
> --- a/io_uring/cmd_net.c
> +++ b/io_uring/cmd_net.c
> @@ -127,7 +127,7 @@ static int io_uring_cmd_timestamp(struct socket *sock,
>  
>  	if (!unlikely(skb_queue_empty(&list))) {
>  		scoped_guard(spinlock_irqsave, &q->lock)
> -			skb_queue_splice(q, &list);
> +			skb_queue_splice(&list, q);
>  	}
>  	return -EAGAIN;
>  }
> 
> -- 

Thanks for the quick patch!

Reviewed-by: Günther Noack <gnoack@google.com>
Tested-by: Günther Noack <gnoack@google.com>

—Günther

