Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3643A456952
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 05:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhKSEsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 23:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhKSEsC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 23:48:02 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4EC061574;
        Thu, 18 Nov 2021 20:45:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id o4so8283629pfp.13;
        Thu, 18 Nov 2021 20:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WYxBM7E+DXLajudk0Iw+qae0dFuTPjJ00RaPfDnZdrM=;
        b=q43pMTDl0ypnZrSGeWZTiZdwRWcd5564vSYVWRsInL6woetOZBWllewRRFRQfu0z/0
         1F3hUgm0bbDaWC+dr1NLoxQLhnu3homfILY3cVO0SBGKRKqqSqsLRGFf+DxdkbV1DaXA
         YhFIYF08y+wc2R/sl3NB3+ufDrMOhP+zAGocB5fmxV8yd1MpPNpwMMiKgV7Xo/0KmKok
         SFEmMTYQE1WYBcIf0V7Z++jHKi4s2DnTN/COZ+M+gl2gRJg9kWMmt+cjVkR51P8cpaGX
         Y0J3GeIruPlv1ytvvYcXtpQVbWQcEpWq9S2Fetoq6vGiDe3Y48gTUEX0ldE8ylah8TIx
         Xi4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WYxBM7E+DXLajudk0Iw+qae0dFuTPjJ00RaPfDnZdrM=;
        b=hzAs08y8Yg9UayXjqAwh3ZUHz89kBJkYYmvA4niL7xl8wiuqXOgr31XdtIfDASAxYi
         AZrGlTDag643IaCP8kzLjKrIgnkYHbaOOMMOPecxTL9wBGk/xbxlil5VTeAwrKzNtVQ/
         1vEUprFBgs7V+H558ZFryfnmUlwT0zI031B9VL2BC6eOVQQPq91k2hU76XYcXFeznlwr
         HE9zxoLoubYvdWjOH+3+8FSfOn9EHRrWl2dpKzKkA5xQ/niTvOtsgVv5Qi1YXEQEqyTa
         Y/P5U7gF1EtStvGDFsnkCu1MvIhU/P6HZUzErmL0rkbDDGaC3hF3KOl1CdKkEjSkJx1v
         0mpg==
X-Gm-Message-State: AOAM532VrIPsiNhwcHEwa9m9qaDlHmUFJHouLNzyO51JtiIOKUqm0oVj
        eigA/SuvPSZhtUhT7prlPa0=
X-Google-Smtp-Source: ABdhPJxDfIqzNdXBp+72aGLZluHUfzdGJ9Yr/liq9TgPspYQqNuBu8zdv8iX8qQ/kUPONT08cVxHyg==
X-Received: by 2002:a05:6a00:2441:b0:4a0:ddb0:a6ff with SMTP id d1-20020a056a00244100b004a0ddb0a6ffmr20709667pfj.74.1637297101122;
        Thu, 18 Nov 2021 20:45:01 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id z16sm928204pgl.29.2021.11.18.20.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:45:00 -0800 (PST)
Date:   Fri, 19 Nov 2021 10:14:58 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211119044458.il4qq5cpnw4xijyl@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
 <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 19, 2021 at 09:45:23AM IST, Kumar Kartikeya Dwivedi wrote:
> [...]
> E.g. if we find that fd 1 and 2 are registered in the io_uring, and buffer at
> 0xabcd with len 128, then we first restore fd 1 and 2 (which can be anything)
> at restore time, then after this restore is complete, continue restoration of
> io_uring by executing file registration step for both [0], and depending on if

This was meant to link to https://criu.org/Fdinfo_engine.

> [...]

--
Kartikeya
