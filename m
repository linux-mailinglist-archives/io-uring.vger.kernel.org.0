Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85BF6FDD76
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbjEJMIn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 08:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbjEJMIm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 08:08:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D5D7D85
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 05:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683720474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBHRFYfYRKquYIG9IbgfFHCMnVDomaQ80tiU2jYECfk=;
        b=hIcAHqV70db6RdTE2LLfehED66qHhJ4bu5pA+P2KT/4czgn/fAzQBmvdD+AcfBB/WkfhxN
        mv2/bnrMOXyO0B5i+9vJB7fewYLyjo39ZGKf2/5pRN+ydI0aG8MfmlnsvXrehp245oGbu6
        rTNsk4/X6aPqaRPInvSjj32D9fu2sYA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-r4R1XbvFMXSd8aOMdcyahA-1; Wed, 10 May 2023 08:07:53 -0400
X-MC-Unique: r4R1XbvFMXSd8aOMdcyahA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-645538f6101so20527503b3a.1
        for <io-uring@vger.kernel.org>; Wed, 10 May 2023 05:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683720472; x=1686312472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBHRFYfYRKquYIG9IbgfFHCMnVDomaQ80tiU2jYECfk=;
        b=R5LnyWiPyiwzNd+uMEVUQJjir/cBDJyed5M1hwJRvaq+aUERUah4ZuDTSK/GZ7mP15
         m5w+M2LUJh3Cc76iGLLNfT7FoUBaj8m6f4I42EhtTNrkWUkhNKXeVqbMdE6Gq/NCQXZS
         pOiwMkGxi0cqXS1bc32tXKaUZJOAEGEED2p6fi9S0jROTAqmg90csn+SSNz0vhJ5cU6Z
         bbsEFHKxx4nAxLaxX+9Vx8Z2AdaUyyECg5ChMD7Jr5wUfY4mtT0k6zxOsr1A13Khdq0/
         k/T0Mx9mV+2KYFJ1APrDZxGRww/6o//g+uImKQvOTKzgzuvqKLiakhLr9dCaspOWMFTR
         i1Hg==
X-Gm-Message-State: AC+VfDzaVIorBGI2X8dMFrt7APWoG7TvLPNjtbQGcxlahoYg/NLkEWh1
        e9uUYIpkSU+kF9dJwZTaQtP9POwR9UAg+xdfzD66q2jqh7qKpioyoLzA1zhgEH+q2CWFr5RtZ2Q
        +FYql7/RTY3MqmFa6AscS8IhubexMRtlowMk=
X-Received: by 2002:a17:90a:ad09:b0:244:d441:8f68 with SMTP id r9-20020a17090aad0900b00244d4418f68mr25722217pjq.16.1683720472467;
        Wed, 10 May 2023 05:07:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7ZiAfNVnQO0UPQ3VAy4kjRuo5FB9+xdUBrPgacbACuNg4amS2P3Jdczy0yCDToSd5CBd6yB5vipAn175sY1M0=
X-Received: by 2002:a17:90a:ad09:b0:244:d441:8f68 with SMTP id
 r9-20020a17090aad0900b00244d4418f68mr25722188pjq.16.1683720472159; Wed, 10
 May 2023 05:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com> <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com> <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
 <7def2fca-c854-f88e-3a77-98a999f7b120@huaweicloud.com> <CAGS2=YocNy9PkgRzzRdHAK1gGdjMxzA--PYS=sPrX_nCe4U6QA@mail.gmail.com>
 <ZFs8G9RmHLYZ2Q0N@fedora>
In-Reply-To: <ZFs8G9RmHLYZ2Q0N@fedora>
From:   Guangwu Zhang <guazhang@redhat.com>
Date:   Wed, 10 May 2023 20:08:57 +0800
Message-ID: <CAGS2=YqNEVngkP2yWb78KuS46Xy6QWuk2qMCswOXRW-AgFgU3Q@mail.gmail.com>
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address: 0000000000000048
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,
Don't hit the issue after apply your patch.
thanks

Ming Lei <ming.lei@redhat.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=8810=E6=97=A5=
=E5=91=A8=E4=B8=89 14:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, May 10, 2023 at 12:05:07PM +0800, Guangwu Zhang wrote:
> > HI,
> > after apply your patch[1], the system will panic after reboot.
> >
>
> Maybe you can try the following patch?
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f6dad0886a2f..d84174a7e997 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1303,7 +1303,7 @@ void blk_execute_rq_nowait(struct request *rq, bool=
 at_head)
>          * device, directly accessing the plug instead of using blk_mq_pl=
ug()
>          * should not have any consequences.
>          */
> -       if (current->plug && !at_head) {
> +       if (current->plug && !at_head && rq->bio) {
>                 blk_add_rq_to_plug(current->plug, rq);
>                 return;
>         }
>
>
> thanks,
> Ming
>


--=20

Guangwu Zhang, RHCE, ISTQB, ITIL

Quality Engineer, Kernel Storage QE

Red Hat

