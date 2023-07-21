Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100DD75D724
	for <lists+io-uring@lfdr.de>; Sat, 22 Jul 2023 00:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjGUWI6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 18:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjGUWI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 18:08:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089932D79
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 15:08:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-262e3c597b9so1454822a91.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 15:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689977334; x=1690582134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnYO1MrUb/w7bGXnvf9jHvSBYj/+oGWWGWz/LdAiRqc=;
        b=YMkkoC9QknWaAmzM7vsdmv8nGcJTFcIs2HyYzzu+YITM160ZoWGlhrIx5n4ub+BYFt
         Vv2QjnQWtyoqus0AkrX1CD6PYL1vvxBbZs6mJPVtVqq0kzo8OUWy3ZawleLTkRHW3Yp5
         82pkcCNi4IQCt/qH0ESw+QaqInsqze3sNQuMufC1WBZAY15H7raREAH8NtauWPpV5KAa
         dHoilxXNLnRfsgDYg+KuZJtixaw/usIKc31EX3sy2LYgquoU5YcIKVG0/gC03+Q0io4S
         S5YNP64NLyW0qiwHPcHVzGWkjMpxv9tlAUpZ+CiD7jyrA5BZDvMV+dG+P9rSQHfRdiWW
         0ABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689977334; x=1690582134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnYO1MrUb/w7bGXnvf9jHvSBYj/+oGWWGWz/LdAiRqc=;
        b=dB85LQVhT5Bm4DSyJS60ejf0WP7TUGFEaJJaw5mVZ2pX/YFNuZDnmtCdEth4l8PJZq
         nU0qXBuNcwzn4ertZgmY20Sw6JoJSpsWB9En9wy/2pQaP5A3HstYjaL97CU4kkz2MUKT
         TRpAS7cLFdoriryM1WmeTo7eul5lyTUgWGWxOP3fKQ6a4Fnmt804qP/LYnym3yp6NOyC
         T5hCPl6v3610MdGMKKpZTngIwZWgfNTGtFeI6zEe7OLwrj2wcvMlora4H5RqOL7+gVlg
         f3ktFlxaSQ42nomRD9+rGBnX3W+V0ZgCLcWyidXGxXGmNUpkiaF79+edyy8UKHb6Pmt/
         LdtQ==
X-Gm-Message-State: ABy/qLYYut9QOMdeefSwGLDFIgteKO7rrU9dbQhNaBGxwCTBCisTrIq0
        Au7SXSnFTRo0c4s+CJlrokdQ3A==
X-Google-Smtp-Source: APBJJlGVLuGK7Lc1Zu6Kwr3WZbjJVOtJQcubDLfHH2epQoVZiN91vc3ytlpe34PmhijS1eUCIYp7xQ==
X-Received: by 2002:a17:90a:b30e:b0:262:fe45:860b with SMTP id d14-20020a17090ab30e00b00262fe45860bmr2675469pjr.0.1689977334298;
        Fri, 21 Jul 2023 15:08:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id gf4-20020a17090ac7c400b00263d15f0e87sm2922941pjb.42.2023.07.21.15.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 15:08:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qMyIt-008vDs-18;
        Sat, 22 Jul 2023 08:08:51 +1000
Date:   Sat, 22 Jul 2023 08:08:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULL] Improve iomap async dio performance
Message-ID: <ZLsB80ylEgs6fq13@dread.disaster.area>
References: <647e79f4-ddaa-7003-6e00-f31e11535082@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <647e79f4-ddaa-7003-6e00-f31e11535082@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 10:54:41AM -0600, Jens Axboe wrote:
> Hi,
> 
> Here's the pull request for improving async dio performance with
> iomap. Contains a few generic cleanups as well, but the meat of it
> is described in the tagged commit message below.
> 
> Please pull for 6.6!

Ah, I just reviewed v4 (v5 came out while I was sleeping) and I
think there are still problems with some of the logic...

So it might be worth holding off from pulling this until we work
through that...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
