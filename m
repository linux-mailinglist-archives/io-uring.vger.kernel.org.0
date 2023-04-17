Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E026E4A7F
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 16:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjDQOA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 10:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDQOA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 10:00:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3B9003;
        Mon, 17 Apr 2023 07:00:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f096839f72so16398715e9.1;
        Mon, 17 Apr 2023 07:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681740017; x=1684332017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=As3N+DrtQ6raqrH+805ObsScr0Zt0AbJ2ISLA6BSiDM=;
        b=XiRteR7Ir6ZKovA5xtpgeeFnixoor8e5OJSllcyrZ1m6UXKkhh6iHCSCKd+ZqlxSRR
         SKhU70WNrmfyT71ZaCV3HCK33LnWTF3Ht9qHcNEdvR+dRpS9Y9Q0XN6y/a7UELhKsFOQ
         McRbVli/j+H15T9ZmtNWS3RKpZBjfDBjgo7LtAE1QPuyskfnYsMiYZUXxc6WC1FFzo1x
         CyTp6QW5tDAT4b+1G7YQFsBeApgHVckABjCayp5XAihH2l73erS2C/Aa6E6gIiLZMhL8
         IQskqIKSr945UHhgcazXBUQpDhs78U0hyvGAVlryLXiU0Dg+QfXeEbSaKuOqAs8D3qhy
         Br4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740017; x=1684332017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=As3N+DrtQ6raqrH+805ObsScr0Zt0AbJ2ISLA6BSiDM=;
        b=GO+hFh8w2Xcxcjg467uU8qzsURfql7TdYu7Dm4x66q0pmrQMd3JfePK5iVlaN0NgKi
         kShk8nCWUVM3Gvv+pLnHW/EmZkXyxML5PlGDb9+urVPxrbfT0D/2NWiuhr3DGirYYUVO
         C7SCepbH+m4PnNzJlJC0g4Hqa7d0o6wcJM+B3e5Kq2PE1fEgjlxz5XdmHvcnBlJlz242
         Ek/zZ7/mEqQnBgTPECQ0SIK5jwSZTAhVBuaHjVZ3QbuLNyYjOywtK8iidivkz8NnC0bw
         OgDXrCGaUOUImdui5DjQAxgs+jGLyTb2HUl+92A9UhB7l+PM4eOQNOr7pXgozR0Uucg0
         2GYQ==
X-Gm-Message-State: AAQBX9cS5pUWm47SfhujDifjDCyHoUSJi3jbmM30k+9OpXxD1qWo4GnL
        wGKVyk9I5uf1OSS4BZTO8ek=
X-Google-Smtp-Source: AKy350aSnN4JtWypJ7B0dqpvH50sKAnXYTSDJAB1Uef+tD6SGnbDa8WcWX7WPcYUZoF0Mqmbj7FCsw==
X-Received: by 2002:a5d:410c:0:b0:2f0:dfd4:7f49 with SMTP id l12-20020a5d410c000000b002f0dfd47f49mr4916966wrp.26.1681740017372;
        Mon, 17 Apr 2023 07:00:17 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id y11-20020a056000108b00b002f013fb708fsm10671449wrw.4.2023.04.17.07.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:00:16 -0700 (PDT)
Date:   Mon, 17 Apr 2023 15:00:16 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <34959b70-6270-46cf-94c5-d6da12b0c62d@lucifer.local>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1I8XlSBIYET9A+@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 10:26:09AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 17, 2023 at 02:19:16PM +0100, Lorenzo Stoakes wrote:
>
> > > I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> > > io_uring open coding this kind of stuff.
> > >
> >
> > How would the semantics of this work? What is broken? It is a little
> > frustrating that we have FOLL_ANON but hugetlb as an outlying case, adding
> > FOLL_ANON_OR_HUGETLB was another consideration...
>
> It says "historically this user has accepted file backed pages and we
> we think there may actually be users doing that, so don't break the
> uABI"

Having written a bunch here I suddenly realised that you probably mean for
this flag to NOT be applied to the io_uring code and thus have it enforce
the 'anonymous or hugetlb' check by default?

>
> Without the flag GUP would refuse to return file backed pages that can
> trigger kernel crashes or data corruption.
>
> Eg we'd want most places to not specify the flag and the few that do
> to have some justification.
>

So you mean to disallow file-backed page pinning as a whole unless this
flag is specified? For FOLL_GET I can see that access to the underlying
data is dangerous as the memory may get reclaimed or migrated, but surely
DMA-pinned memory (as is the case here) is safe?

Or is this a product more so of some kernel process accessing file-backed
pages for a file system which expects write-notify semantics and doesn't
get them in this case, which could indeed be horribly broken.

In which case yes this seems sensible.

> We should consdier removing FOLL_ANON, I'm not sure it really makes
> sense these days for what proc is doing with it. All that proc stuff
> could likely be turned into a kthread_use_mm() and a simple
> copy_to/from user?
>
> I suspect that eliminates the need to check for FOLL_ANON?
>
> Jason

I am definitely in favour of cutting things down if possible, and very much
prefer the use of uaccess if we are able to do so rather than GUP.

I do feel that GUP should be focused purely on pinning memory rather than
manipulating it (whether read or write) so I agree with this sentiment.
