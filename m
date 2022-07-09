Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C266E56CB12
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 20:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiGISag (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jul 2022 14:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGISaf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jul 2022 14:30:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D60F22BF1;
        Sat,  9 Jul 2022 11:30:34 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z12so2198512wrq.7;
        Sat, 09 Jul 2022 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UzXTEzvirVIfQgpRsZ+S3IQH5KHrdqAU7esxyuqlcI4=;
        b=azFPTNNmWWMPgUFKlPXqmgq48Ky1+NFueWA8CeF4u6bOZNNqI/ZouXYtrZzIQI8369
         tHNRrJbP3Sk+Qceww9e7NnrcuDgJ6oXsFN+7UXhcMdUokeJ6YJlHAlJxMvos2ldKLn3j
         7qnyIMJNcvc4n+99h6ZoUqIl96IBxZcSLUP2Row3p9htPHtQDjaOVGMxEPZIg0ThAzku
         JP/YMWoEj/7gz/zYLt8XR5fUmxUTGzc7A4L/NsKoD1clU44nb9/glj7xUMteE9ztqdCY
         xScs/VQryAk4+7BFaPGN8I56D8qyIDvJpCmOtxLQds1DYNF1pzvoTJw1JwfwK48t37Iw
         OhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzXTEzvirVIfQgpRsZ+S3IQH5KHrdqAU7esxyuqlcI4=;
        b=1WErL9gRAaSUpnV0O/zACf4Otbi+i9fUONTvA1FYoTZAuIbhVSkeUPGZjUQ9YyBTmH
         s73OnP6+Oug3htKeQDoK+MOhoQhiB9xFNUQuY8oBrN/yBEMa3cdGA6cXoAJ6sUZ9HTsK
         yHGXkUcZDxjfmf3XV03kem1hgF9T5ARn3kgGHjLCjwOcr5Pht+NRpLe/W+c5BAcbDZNI
         l42wgKlTbWBBQM01NTFuj33NUKD7y5/Vq6bfSpXBVmrMvp0cugi8Gp/6blFABvnjIysU
         NJ1nrL4RBcbwmAIklKSndGKM9ENUo7ACqT9gr+Vr+JlWSXVpAPfAb11/A4eJZYtig5vI
         sgYg==
X-Gm-Message-State: AJIora9C/tSKcYWnLs92tN6Gylh1OvJFoP3SKmiI/ZQb9pgeOKR+QzKe
        +aHHJOBSOFWVU6I0rcBk1Bk=
X-Google-Smtp-Source: AGRyM1tAtrtLBOTNfS7tOy8h/BBFOAIT9pR7nVNc89ZMI3mrlIbdzOc1A9K2XpDn13ZLjn4N3vi0ng==
X-Received: by 2002:adf:e0c9:0:b0:21b:8271:2348 with SMTP id m9-20020adfe0c9000000b0021b82712348mr8620979wri.222.1657391432677;
        Sat, 09 Jul 2022 11:30:32 -0700 (PDT)
Received: from opensuse.localnet (host-95-235-102-55.retail.telecomitalia.it. [95.235.102.55])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b0039db31f6372sm6358721wmq.2.2022.07.09.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 11:30:31 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nvdimm@lists.linux.dev,
        io-uring@vger.kernel.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Date:   Sat, 09 Jul 2022 20:30:28 +0200
Message-ID: <5600017.DvuYhMxLoT@opensuse>
In-Reply-To: <YsiQptk19txHrG4c@iweiny-desk3>
References: <20220630163527.9776-1-fmdefrancesco@gmail.com> <YsiQptk19txHrG4c@iweiny-desk3>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On venerd=C3=AC 8 luglio 2022 22:18:35 CEST Ira Weiny wrote:
> On Thu, Jun 30, 2022 at 06:35:27PM +0200, Fabio M. De Francesco wrote:
> > The use of kmap() and kmap_atomic() are being deprecated in favor of
> > kmap_local_page().
> >=20
> > With kmap_local_page(), the mappings are per thread, CPU local and not
> > globally visible. Furthermore, the mappings can be acquired from any
> > context (including interrupts).
> >=20
> > Therefore, use kmap_local_page() in exec.c because these mappings are=20
per
> > thread, CPU local, and not globally visible.
> >=20
> > Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
> > HIGHMEM64GB enabled.
> >=20
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
>=20
> This looks good but there is a kmap_atomic() in this file which I _think_=
=20
can
> be converted as well.  But that is good as a separate patch.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20

Thanks for your review!

I didn't notice that kmap_atomic(). I'll send a conversion with a separate=
=20
patch.

=46abio



