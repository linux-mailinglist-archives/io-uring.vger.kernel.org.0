Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E74EC551
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 15:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiC3NQY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 09:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiC3NQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 09:16:24 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B25220EC;
        Wed, 30 Mar 2022 06:14:39 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-df0940c4eeso8545532fac.8;
        Wed, 30 Mar 2022 06:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1nMim+eDxDf/5PKoFQWnd0bc2gDZtzpNJd3Is7aeZY4=;
        b=OO5qym66qk0XlxKttsyfA46hGzSbNVjvrT/LxJlPEiiqAz4AOlcErzm1ffT2k8o7B8
         307OYsfFOYzDkF/kiz6EcRTBnGTWAgeCDdfnAU/EdCSMlrhOaZqmo6eOAVojefshckW8
         ndlDVekcZ9riKZweXxxyTUmP2zQFfc8uFG+7aLJm5Td3z4ZLEH/S5PTpGFT4BuI3fWNa
         SV86A1+K0q2lgb4oxXG3dEzPkkarlR+K8+VudDymSYFvjfBUr25FQufpE4iv+Z5O7/LG
         DtKFfqdbLu/ZcIyJjMSWXwa8jnYTwmhMf97Be1YIgeptlIyx9apeyjB7LpmQEMt0jsa8
         9Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1nMim+eDxDf/5PKoFQWnd0bc2gDZtzpNJd3Is7aeZY4=;
        b=UyiOG3TzgRSOngPCMjb4jPqJatL6hlJOpvYAOLvapn/Rh2Abt96Ew3gHyieXhZvnQJ
         3UbC3vpmzwTDPcsXi1gN8tVUaE5Cvj452znVH8W1PwpVQ0J5y0K9+8l3vU8wZ24jstK0
         ZVRVdFRrPe2iVVvF98ga+b5vAjm5S6ErXJg59p0xQTv0y6htp0W2s7xinWKzgtalsOP3
         X/IWknKwEZBSKX4X59SiJhhkd5P2vwrVc3x7t5M7FT2fX4iziTButtjm+Aw/vjXKHDe6
         +++444/1KA+xrKRdzbE1K20OaxbrCsRa7mp3b3LyHgZp6sN6MeBAcBOc7NVJualN444e
         gDeg==
X-Gm-Message-State: AOAM531//gIrKkJ5QBhVHXq8L4sinvfLGw7Da6V4WlZfJEV8uy9lxfTD
        8Q3ZG96zJZGoJWjr+bVAzuB09EDTSrGigjBUNA0=
X-Google-Smtp-Source: ABdhPJxjFqw1iL+mE7nQo5TNi+cZ3oFVY7P5u/Ty0k4rd+2f0SFlkNu4vS/GbISpH8YqSLOOLjyeWPP6F1006rYG4GI=
X-Received: by 2002:a05:6870:c154:b0:dd:986c:afa9 with SMTP id
 g20-20020a056870c15400b000dd986cafa9mr2052493oad.160.1648646078446; Wed, 30
 Mar 2022 06:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns> <20220330130219.GB1938@lst.de>
In-Reply-To: <20220330130219.GB1938@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 30 Mar 2022 18:44:12 +0530
Message-ID: <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 30, 2022 at 6:32 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Mar 25, 2022 at 07:09:21PM +0530, Kanchan Joshi wrote:
> > Ok. If you are open to take new opcode/struct route, that is all we
> > require to pair with big-sqe and have this sorted. How about this -
>
> I would much, much, much prefer to support a bigger CQE.  Having
> a pointer in there just creates a fair amount of overhead and
> really does not fit into the model nvme and io_uring use.

Sure, will post the code with bigger-cqe first.

> But yes, if we did not go down that route that would be the structure
> that is needed.
Got it. Thanks for confirming.
