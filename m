Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC106E817B
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDSSvD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDSSvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:51:02 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE363C1F;
        Wed, 19 Apr 2023 11:51:00 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v3so193402wml.0;
        Wed, 19 Apr 2023 11:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681930259; x=1684522259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ezek+yGdnnG3GJVW/T1zFXIXfyJ7BG3LMN7NClKXUQI=;
        b=TW+V7PnGQiMShWp6b+GsPudVaJ/F5vEozWItp02wq0Bg4V0pcfX96UMs/PnfoK3SxO
         AA7blAs+JWp9bQGXg1PYOB38yvBy5xKaelzUF1J630FyAzfzv4vkn2IwmYgUk2CdJRUf
         l2x5jxLtTsKESRkIszJoguNMoFjZN3DK078oo1zvm0hwtskDRNXJNSHJkOyVsyA9tEaJ
         gsxl5EX94C04ZfuiRAmKJaIJdX0FCyMCczMlcZVlJjL2JXlzGwIrWVzWk6nMCC9bIrAC
         RnBeSjIDg3GIODW3DZgqjM6tV+/MO6cI6fk8unPAnID1TfQaOiTyqVyDl/Ou3gwG4S6F
         uH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681930259; x=1684522259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezek+yGdnnG3GJVW/T1zFXIXfyJ7BG3LMN7NClKXUQI=;
        b=k95rgveD7EWiUBZfSb345eGuHQa7K+he82NWGo6HB5yz5+EJZiVIWJMcx/9R2DD9GD
         P8Gkhf/+4p9maqpEPRSmhRjTpC1hbG2W9cZ0h41P2oCC0PtqA/Sf1B2ci7v8fXrSxrCh
         yDvmVfoxQtFMgkLLZ0t2gDvf1sPgnejBPTXtFqwlcVNTtgfhRZM0zMu7Tad5sFMyRnl4
         05inUskLmockOdarTlsxOJfwWuGsuIWZs0lRfIrLU9v8gB5fm60r4y392oRXoLi2DZSa
         HkqJdo/Jhm7F8Fnc+rOJWYXxv2EzQui9U4jljRd7dS9i4ipObZuLXa7vf6+ATx5vMYcw
         y74w==
X-Gm-Message-State: AAQBX9dOLUpjTai89FOeZ0ObUciCnPYWYu3DNe/N5kKjWrPIigl++PTb
        7+1HfAg4gIyN++hvFeV7DS8=
X-Google-Smtp-Source: AKy350aCMKl7s7ZFuKxcGSpTyd5/sxX+RcpUIQUj2w0/TyGo8VroRs/8PwT6ZDtQmXhJ4xZMnD94Bw==
X-Received: by 2002:a1c:ed19:0:b0:3f0:a0bb:58ef with SMTP id l25-20020a1ced19000000b003f0a0bb58efmr17698094wmh.25.1681930258816;
        Wed, 19 Apr 2023 11:50:58 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id z21-20020a7bc7d5000000b003f17848673fsm2974811wmk.27.2023.04.19.11.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 11:50:58 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:50:57 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <0a41fd0e-39ce-48a4-b47b-53cf4cbb050b@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxW/yR3LCNSmjT@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEAxW/yR3LCNSmjT@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 03:22:19PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
>
> > I'd also argue that we are doing things right with this patch series as-is,
> > io_uring is the only sticking point because, believe it or not, it is the
> > only place in the kernel that uses multiple vmas (it has been interesting
> > to get a view on GUP use as a whole here).
>
> I would say io_uring is the only place trying to open-code bug fixes
> for MM problems :\ As Jens says, these sorts of temporary work arounds become
> lingering problems that nobody wants to fix properly.
>
> > So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> > would still need to come along and delete a bunch of your code
> > afterwards. And unfortunately Pavel's recent change which insists on not
> > having different vm_file's across VMAs for the buffer would have to be
> > reverted so I expect it might not be entirely without discussion.
>
> Yeah, that should just be reverted.
>
> > However, if you really do feel that you can't accept this change as-is, I
> > can put this series on hold and look at FOLL_ALLOW_BROKEN_FILE_MAPPING and
> > we can return to this afterwards.
>
> It is probably not as bad as you think, I suspect only RDMA really
> wants to set the flag. Maybe something in media too, maybe.
>
> Then again that stuff doesn't work so incredibly badly maybe there
> really is no user of it and we should just block it completely.
>
> Jason

OK in this case I think we're all agreed that it's best to do this first
then revisit this series afterwards. I will switch to working on this!

And I will make sure to cc- everyone in :)
