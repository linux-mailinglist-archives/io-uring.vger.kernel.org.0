Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB845695E
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 05:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhKSFAE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Nov 2021 00:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKSFAE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Nov 2021 00:00:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC9C061574;
        Thu, 18 Nov 2021 20:57:02 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so7218696plf.3;
        Thu, 18 Nov 2021 20:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3qHU6p+rGNqJTq8NPrlgksyGvJviCt3RjQLXnkZaz0=;
        b=mXOVSGG5fbYHYYuc/92K+Dame72L/iLAk63fLQCORRIuoEzwPKmXIlLqQ2Rmzq2lNH
         DMAUj3Q9cglgAvENYfX70ps2AKmevGXmqEMgbCXqi5fdB/zHSPz3MzlEnapJ8bNtUImf
         J2ongkwkHOmMryQemWfn2XQnwMs20A2S1CF8OflwolLIRptdKPojY1tdav8x8ymZHGM3
         ld5/QP1/krS5tNCnRjEZsnf8WBffkoFt+1jr9Rg2ptJqJy3kJfEIdwZ3MatTL39SEQW3
         xQ0XxcFsodkSylnZymjSiWoqtZuCrTdSYRY9s2oCy4mpLAwGaHeGW9S+ezwUB4TIXKou
         TepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F3qHU6p+rGNqJTq8NPrlgksyGvJviCt3RjQLXnkZaz0=;
        b=r0ugwUBLXWxXYhRGQY9wFpFqoio5+/GzqgnjoEajRLXAmKUSZIshvLtFeJl+OVby7i
         KEAjAo+MLOAUL8OnFaFg/NJRGK8NVR+yCqwQDWRNy4kzuRXbfRDfO/+qCtAOMJ/NyV+V
         ZtbDznrDm9dbP19//vI0OaC4OH/YfBRq9zynN23Hqa+DmtYzCKJxyuGej3I+7GE+6HQE
         p3SaaI8Rvj3ogNnPHzTOfXmlEPlUFxvM25rOxCB4T1TrB1fsCG1GJVcnFLJMpn+NwBjT
         r0qPaNJke2LzRBmbwsbmnR8kpzd6Xi6Nbygt2YCmLSAsp54B54Cc9dVz+FtSoz/guvKi
         h4jQ==
X-Gm-Message-State: AOAM531HZ4gZi7haKZV8hwEed7p9YP8+vAiehH5x0j/02oSbhCYIYljF
        bl50lyESzyCZ0pmhrJsegLs=
X-Google-Smtp-Source: ABdhPJw7eCc4eay38Sl3DjBnRnNmNBnCjKU8/WVLfR3gu2W6Jhcc/ryzstSwntOYjw6vpLr//fM5ZQ==
X-Received: by 2002:a17:902:bc8b:b0:143:caf5:4a0e with SMTP id bb11-20020a170902bc8b00b00143caf54a0emr39242506plb.38.1637297822483;
        Thu, 18 Nov 2021 20:57:02 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4e33])
        by smtp.gmail.com with ESMTPSA id d7sm1276597pfj.91.2021.11.18.20.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:57:02 -0800 (PST)
Date:   Thu, 18 Nov 2021 20:56:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211119045659.vriegs5nxgszo3p3@ast-mbp.dhcp.thefacebook.com>
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

On Fri, Nov 19, 2021 at 09:45:23AM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> Also, this work is part of GSoC. There is already code that is waiting for this
> to fill in the missing pieces [0]. If you want me to add a sample/selftest that
> demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
> certainly do that. We've already spent a few months contemplating on a few
> approaches and this turned out to be the best/most powerful. At one point I had
> to scrap some my earlier patches completely because they couldn't work with
> descriptorless io_uring. Iterator seem like the best solution so far that can
> adapt gracefully to feature additions in something seeing as heavy development
> as io_uring.
> 
>   [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
>   [1]: https://github.com/checkpoint-restore/criu/pull/1597

Is that the main PR? 1095 changed files? Is it stale or something?
Is there a way to view the actual logic that exercises these bpf iterators?
