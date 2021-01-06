Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A82EBFFD
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 16:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbhAFPAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 10:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbhAFPAR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 10:00:17 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EABC06134D
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 06:59:36 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id 2so3427133ilg.9
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 06:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7xF84lcqYmAAeGxt+k7XGd8Gw2sYr7n9FyENDhOQeBw=;
        b=sAnegShUdfKFxiA32+4xESBnuY/EPkZaZb6wLwtKllDrHMQhanQMGXUyeUqCt9xJSY
         51EgOriwv4gMaUbQEFuYQiUREGGxR9YNULwoTT0G6eD76v1RRA7YP9CZ4NTTdDlxKIqI
         FoBiv35xOk/GD9/BTctPcerulP5RCslMdt3wuzTF6DgDTWv5oJeokBi03CBsp1H+clNk
         6mBE/NdzWvgMjE6S0aXDd+Evb4C3U/Ne1UfyJGHRdt8S+twol2AyTMDQoFJTAZCCR2wC
         7c6m5D+g53/p3U1TCGGSZKDoRS35zgCIUIvowR55YWL8TSeLXAJumxrguOdMcEUaLi0J
         I3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7xF84lcqYmAAeGxt+k7XGd8Gw2sYr7n9FyENDhOQeBw=;
        b=qGXvRazlwMD8VBBUdNkYAjfPhUjQmYpHrjjL9LBPuQYQMp3GLAYRD7sCXFUN01iuAA
         VuD8z2SG6QQ+GlByUE2eyF+MSmLIeN8LaFTkpk5jsw6BD4Bieo5fBbTvz1fnul11Kn+5
         IvS05kf8XFhpwsO2nuXGCw8di+H4FpL0z8QQ3f+iS67eQGPQtIVqQjfPot3ap6buH7yG
         iDXixuknL2UXtTwHdZyT+U948hyg+QwjM40d/NkjL8kpCNMtcYnHL0kLMOXfIziQiVek
         FR5GAIcqmrTGOYNo9q46AIQ7RczyL23fAgoatwLhjHZxjxKxMjqRwqTdvK3DVZuBBZnh
         GfMA==
X-Gm-Message-State: AOAM533TFWLDG9w+eX3h5OnkJeMEdw3PFpgtHYccVEWTA/MjJbz09GOJ
        abytaYFaEvlRRj0wDXUWR3+l0w==
X-Google-Smtp-Source: ABdhPJz5/o2xLu7ZN4Ac/qoFB2INGnPTWbbUk52VQp+HkSUMCJ4zqImKuS2wfqiv8/Y8aMytmRhkIw==
X-Received: by 2002:a92:6512:: with SMTP id z18mr4510745ilb.220.1609945175933;
        Wed, 06 Jan 2021 06:59:35 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f2sm1527141iow.4.2021.01.06.06.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 06:59:35 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix an IS_ERR() vs NULL check
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <X/WCTxIRT4SHLemV@mwanda>
 <c88d8500-681d-7503-77ca-ae10d230a11b@gmail.com>
 <20210106143401.GD175893@casper.infradead.org> <20210106145610.GC2831@kadam>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4ba258d5-6097-ca9f-4467-6392404030cb@kernel.dk>
Date:   Wed, 6 Jan 2021 07:59:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106145610.GC2831@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 7:56 AM, Dan Carpenter wrote:
> Jens just applied my patch right before you sent this.  I don't have
> strong feeling either way about this.  I guess I sort of agree with
> you.  If Jens can drop my patch then it should be pretty trivial for
> you to add a commit message to your patch and give me a Reported-by
> tag?

I can just drop it, don't feel too strongly but would tend to agree
that we might as well just make it NULL/pointer as it's a single
error value. Willy, are you sending a patch?

-- 
Jens Axboe

