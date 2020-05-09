Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF11CBCF7
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 05:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgEIDa3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 May 2020 23:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgEIDa3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 May 2020 23:30:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CB4C061A0C
        for <io-uring@vger.kernel.org>; Fri,  8 May 2020 20:30:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b6so1586326plz.13
        for <io-uring@vger.kernel.org>; Fri, 08 May 2020 20:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mhP8WlApXsmxKUxMxHyGB9cXYz3ZMDdZWnzpx3gHLjQ=;
        b=kvz+ptryMagrAvaKJQInk9vHFnbCyHx2ofYRCF/e3BQrhMFB95jhw66zO0947nunIP
         rsvrjoNasC9xf+gTk/bkhlTeimOZFeeoTXyfDWI1e53+/nLsm2nJecn80TWQnl27w9mb
         WEjvoNH6SiIP5ijY2+vOtBIaWjhhBNCG1fwsO9zr26Mpata3VpHObiJtaHnnaP6n7cuO
         9etmvIVN9VYZJoWd6mlCKO/NLLnzdJq3UttOGOF13jfRPfQGaIj2oKWtIth+IY8McR+b
         KX4K30GltVxwDyRecl9VWo9grzqAm1CwJ+w9c/ADRgmb1o/T3/MDdGmFnX/DJVMGX1P9
         Gv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mhP8WlApXsmxKUxMxHyGB9cXYz3ZMDdZWnzpx3gHLjQ=;
        b=dFZMDAP1KpgoTnDrD320/W5c6D6XpOGjgEhF963N0n3Psbv0MjOEiossL0WILXLmO6
         IXcoMX0cuvyen3tz/3rbfJ8coBRXzVRgK663MlGrHHMThDbXqiUTlv9Hvj/S6iaGYXmu
         QRqBeXAnN1TqYxmjMwfVFrQRUyW8h+wKBePYYbCKEybT9jmZtXFFZ7UzOc+Za+nOexwL
         mG+mXZ+4TxxzI1eZuAOUk+dQlQ09X/wYptVyBFCeEiy4Dmseknu4eNGLx6yAdTxXuWxW
         28EjAC8rHcfgQvF7wBp1yrM4l4PGYF2KU2kN5ETjrrJY724765BXMeCf3mKJ8O8E7Itt
         IZrw==
X-Gm-Message-State: AGi0PuYY03cnvfy9kxPohPDAYWXLZ6nEgJr3ob5WRgdL3DV3Mk9HAclS
        fdzc2mtZcxIYxPEGIHxfyDsc+LDrGGI=
X-Google-Smtp-Source: APiQypKKGpsCg9nBOdp1edp5RKml6NjjNazdiiYf3qUl21Ki7omdxMw+sYNOFUd5H+elkpyHkNcp1Q==
X-Received: by 2002:a17:90a:24e6:: with SMTP id i93mr9387269pje.13.1588995028386;
        Fri, 08 May 2020 20:30:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d184sm3101562pfc.130.2020.05.08.20.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 20:30:27 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove obsolete 'state' parameter
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200508131930.38743-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <334bbc31-6084-eac3-6731-fa0d5a0f3ba9@kernel.dk>
Date:   Fri, 8 May 2020 21:30:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508131930.38743-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/20 7:19 AM, Xiaoguang Wang wrote:
> The "struct io_submit_state *state" parameter is not used, remove it.

Applied for 5.8, thanks.

-- 
Jens Axboe

