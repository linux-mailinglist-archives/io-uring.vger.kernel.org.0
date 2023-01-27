Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB71067EEAE
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 20:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjA0TpX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 14:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjA0Too (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 14:44:44 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF521B540
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 11:43:23 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a184so3990837pfa.9
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 11:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmDDVckbP60b67QFuvxzlip37K6XOtYFQo26wANXj3g=;
        b=S3HghOQMbc29kLHG8ZRVGX9752gyA6Spa3lcoxP2nFGgb+A6ulZSpBTVyNzvy4mWh7
         7hYMn00JdM8fcR8oL+RuSe7aBBeIW/iSOZUArPwW5U7WiVDXo/5zc9msUSJ/lWCslPNZ
         l1uAvJSv7N26TgifuWGmqc2abV311vQKZrbW9kawMsVb/vLUmMnUnp97ePljtUVLz8uP
         hlqBTKX7dT+E8JMuLlzDY3nRUDC2gGNT/WscJOIFP6LF7oW04myl/7gHeHfAusz3f7ED
         yK6vfvOQMgr1EKJaIQrRZugv8Kzew+JnBs1aWx4p54cbPuU7gyRv/uSyxMaybUkdRFZk
         V+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmDDVckbP60b67QFuvxzlip37K6XOtYFQo26wANXj3g=;
        b=V7TakjsmjMGR6eu8OQpNC23Rm7NH1ED0jxoe+cML/jacoaqx9wS5trIHGax4OE6Mgy
         u7l0daZHFqvlOfJZLumnc2UEGy3N2PdWddDe5n8BFd6nER/KM9pcKrODO4ccoskiwGbB
         BwZ53n/X0G2rPVe5hMEEOz8VpOMskMJEaRJx0HrFV5XdeaFK4wjbcgyw9DeOsXKKjgf0
         b4nSCn3S6D1Eh5VNCcO7iClnG8X9P3e8dwGio/PbE6fSoPfyh6NgrdXyzHi3yMKrC2hp
         Q3FtSRQzkI9h+9PGz73+x+nGVtBlYhMH3RNmz7UOFW1qls/LMDCPqpuSqbzTREmXBtoe
         tH9w==
X-Gm-Message-State: AO0yUKWGc6Z19vIVfJb+YEQBtJWQwsmFy2obfWZgp2PDde0RCo0PR38O
        Uak87nFeSK9LWv+LdO+abjHa3N0pPagGVcaI0gP/
X-Google-Smtp-Source: AK7set/EhaMGlKO8EQNDwR2mglpOAt1yI0o594u65BpZ2HPfyXB4F31hvK5EMUvVABTiD6vdFZYnbGsRfqP9gGXCn7k=
X-Received: by 2002:a62:8e0a:0:b0:592:a8af:4ffc with SMTP id
 k10-20020a628e0a000000b00592a8af4ffcmr479150pfe.52.1674848551078; Fri, 27 Jan
 2023 11:42:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
In-Reply-To: <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 14:42:19 -0500
Message-ID: <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> > A couple of updates to the iouring ops audit bypass selections suggeste=
d in
> > consultation with Steve Grubb.
> >
> > Richard Guy Briggs (2):
> >   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
> >   io_uring,audit: do not log IORING_OP_*GETXATTR
> >
> >  io_uring/opdef.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Look fine to me - we should probably add stable to both of them, just
> to keep things consistent across releases. I can queue them up for 6.3.

Please hold off until I've had a chance to look them over ...

--=20
paul-moore.com
