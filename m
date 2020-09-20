Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441ED27158D
	for <lists+io-uring@lfdr.de>; Sun, 20 Sep 2020 18:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgITQFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Sep 2020 12:05:32 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:39439 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITQFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Sep 2020 12:05:32 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2020 12:05:29 EDT
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MkHIV-1kmRhc3esD-00kdPN; Sun, 20 Sep 2020 18:00:22 +0200
Received: by mail-qk1-f178.google.com with SMTP id n133so12380961qkn.11;
        Sun, 20 Sep 2020 09:00:20 -0700 (PDT)
X-Gm-Message-State: AOAM533qKODglS4xYl9kvQmhZXZaVTIiXwaJgVF2yRB76sPP90XoTjCw
        kj9TpYQGvekzM+ISXbnVYovs8FTeynGFIH15g70=
X-Google-Smtp-Source: ABdhPJxWyfvCzQQBAWL//h6npTn88fQ05xaOWJspiDrXO43nFmdBtx69etP6R9R9/pXauFf/MfRV57t9JJqYkZya4Ms=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr42809575qkf.352.1600617619461;
 Sun, 20 Sep 2020 09:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
In-Reply-To: <20200920151510.GS32101@casper.infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 20 Sep 2020 18:00:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0utXQj+yLh3n2mvi-mX_fPnxz3hKB7+wEof53EgNzDvQ@mail.gmail.com>
Message-ID: <CAK8P3a0utXQj+yLh3n2mvi-mX_fPnxz3hKB7+wEof53EgNzDvQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:lNDlWc0Buitw3L4uhuGtwQ92/NRgJbW9dL1xVEoFiwPKF+Mna8g
 BdP2KanFhFZuk3fOTGN57tEkQzL1ph3WKs2AcSgU+CeX+Ab2aERPVddznUdHaAMJppuee5s
 VIzbmjWQQ6+7BmTHrEHpxP7MhzZM11lo/1SLP22iLAA/opCSIrmhMpGbvqQGIi5najpAfXU
 +us3JHjWmqydWqbJaik7g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:koVQKgDw1ps=:5DnzZQRl1EHXfqQOtB9AEO
 8LsJA55f4BHxbC8gAoxD+kRjupir2dQuMbIC8KqnCdIH+kvYSiSkIinTU9xpxUOeb+g32taG7
 zgq6lmW7E5alsrjFHoOQQKogd0w0mc2OGa4QK6KvH3LQo12fLACLCOBRI2wn24vJjLsbxkxRb
 4oYL2jKyvvhL2VnVwPpBwsuSplYCc3GxF+GDG5vQ1yi9F81STd0Poo6xk4GcNSGY9qCM+iV8s
 ws1gkcxwsdvCnL19oa9rOJArnlrJZ1yuLVD/zgEBvYpE6pT4cbDpDxm9wwz8LvBIVVcSvtP+x
 mGyk94+jKKOcC4qo56LW/S6BdlfLKXngB+47S7vyiuguaerjb/f0onmPVCrHlQfMOMddPJI2Q
 iF4PakYD/N03OMnZH0v5aT6z1n9Vsw/WiHVC6UB+iYwnl65YgnV56/uzHE9CWtLgwvLT2LVr0
 2rlO4pJITDI3YgCjOslL0kHeuQBxhsgriFD4o8lWb9XupiqWVmME+nL0OpvCKPqgaEdru2crA
 DHQp2ZOKW/Vrmc9VPnmxTP8IsJi/5omjKJISQ/MFQhjf8n5y3sCSwV5gsRMrIQ78Tv/mYe0vN
 Tbnr8srZbeLfOjwP3pmLLBIhiYojZy9DQcNElLAnvxpGjaYzyghV6Mfy/YTZHWmqSaftc5GwP
 8grNy2d63/jYMUkWJGMhLFNVRRNGMo0ZycHypsyEPRpsrTEWcYnu7jX1YQ8NQKqDRNIaXPOku
 lcyUiNYvv0oeXDvk9dCa/fIcuQJsKbx3iEcteoJ01nHt5W6GiI7gNqZ/J9sU2SoxLMtUzbBN5
 byu/tynrEax34vsa7Kj7rpMoaW+IQI2MlJDDEvcpHvQ1b/DsDYzBhyzBPk0kGcim1jhR59wiB
 c02AOlR+yAnCATNXkBXRLt4fXccXJQIXUEA+8lQUzXBQQz61Cq2yBh/qpLJ9yDAFryEa0EfxT
 Y2XgNfg7XJgsE0EzIhjvN+HfpTmhyKqv8PlD/O0KT7LvHC634CcvqYLogbGi9LtSR0hYjdr3s
 z80HG5R+AV6wWxHfpckQZ2B39gic1ALUxLEB8vinlCM1FeG5vQBv/3ibyRh66P+8IG4U1xwvD
 XXIZ+YgI1v6GUGzoth2LtiY9Ga6lA3L2xY7u0QWjNIdR+XaRSxFFiCuQx1o4l3E3CFTutHgk4
 dwMcdjnfbCv+zXITdgRWP2uabB
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 20, 2020 at 5:15 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote:
> > Add a flag to force processing a syscall as a compat syscall.  This is
> > required so that in_compat_syscall() works for I/O submitted by io_uring
> > helper threads on behalf of compat syscalls.
>
> Al doesn't like this much, but my suggestion is to introduce two new
> opcodes -- IORING_OP_READV32 and IORING_OP_WRITEV32.  The compat code
> can translate IORING_OP_READV to IORING_OP_READV32 and then the core
> code can know what that user pointer is pointing to.

How is that different from the current approach of storing the ABI as
a flag in ctx->compat?

     Arnd
