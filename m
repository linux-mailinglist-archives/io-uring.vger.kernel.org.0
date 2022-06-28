Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D9855EBEF
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 20:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiF1SGE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 14:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiF1SF5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 14:05:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A4F1DA46
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 11:05:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 65so12673726pfw.11
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 11:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pTcGgtfSu6n7KkCWKQ4ciWe5XeKK5S4riO8KfNVW7Ig=;
        b=F/CZTCTDOlhkWqZ+vOzW0DaoZ/EZ1dOhoCSSJ2RrwBNwuY7CCyvEtaLLk8DO+FYVI8
         oY1bh2Rw2NH/e7uwuajkABgxQQynq/vb9wDrQT1ziurYSmeBDoqa9s9XGmGLyXXXVu1m
         Ptj/OKkdrLcBprdD9gQ9RffSNU26yKh9HCJiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pTcGgtfSu6n7KkCWKQ4ciWe5XeKK5S4riO8KfNVW7Ig=;
        b=Uh6sBCzuQBRj5ZjWoLk8HQ5VkZ2scYpEQXWwR8T0MkuEF3lL+aXk3gpqVxURp1eJMU
         4X0r1QOCdPwNR6KSvPhWxF02omh0GUwAVX1siwNDY+cIR5Tc70ixuTBiK29cEVh6E+DW
         gcEoXVZMRGWL+YRqBnyZoOX6bN24RndlQ+u+ePhkwpSvRRVL7LwkLylD0DybFuLmIsWS
         QN05zpmtQsSGT6zCTwK9i7oQyKjA42BBDfSqmgpqNCGO/CGGcf+m7c71eceDy2mnJEO+
         1LTPs8JWnfGfJ/Ud7nErz9RcaVagp61vc7PQnNXAJmQV93NJpy2gEN4Yr4B7DfX1d5O5
         w4iw==
X-Gm-Message-State: AJIora/v2PwwLNEmVJBBDS6UbuZiAexqkRQiKVtGTicl+5HdzmyBBw9k
        DLVSCNtVgyjyx8OyvLA3d42cwg==
X-Google-Smtp-Source: AGRyM1v6cdnwBfGpeB2JnkCbahQ14YUYaqjRd3VUKbR8YPBigZjfWVkzlvmFIFzfbBj+r2XqbA+86w==
X-Received: by 2002:a63:7412:0:b0:40c:fa27:9d07 with SMTP id p18-20020a637412000000b0040cfa279d07mr18441815pgc.27.1656439554674;
        Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902cf0300b0016a0ac06424sm9669985plg.51.2022.06.28.11.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Date:   Tue, 28 Jun 2022 11:05:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        dm-devel@redhat.com, linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-can@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        nvdimm@lists.linux.dev,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <202206281104.7CC3935@keescook>
References: <20220627180432.GA136081@embeddedor>
 <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 28, 2022 at 09:27:21AM +0200, Geert Uytterhoeven wrote:
> Hi Gustavo,
> 
> Thanks for your patch!
> 
> On Mon, Jun 27, 2022 at 8:04 PM Gustavo A. R. Silva
> <gustavoars@kernel.org> wrote:
> > There is a regular need in the kernel to provide a way to declare
> > having a dynamically sized set of trailing elements in a structure.
> > Kernel code should always use “flexible array members”[1] for these
> > cases. The older style of one-element or zero-length arrays should
> > no longer be used[2].
> 
> These rules apply to the kernel, but uapi is not considered part of the
> kernel, so different rules apply.  Uapi header files should work with
> whatever compiler that can be used for compiling userspace.

Right, userspace isn't bound by these rules, but the kernel ends up
consuming these structures, so we need to fix them. The [0] -> []
changes (when they are not erroneously being used within other
structures) is valid for all compilers. Flexible arrays are C99; it's
been 23 years. :)

But, yes, where we DO break stuff we need to workaround it, etc.

-- 
Kees Cook
