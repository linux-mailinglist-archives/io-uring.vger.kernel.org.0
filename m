Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A439A6B63DB
	for <lists+io-uring@lfdr.de>; Sun, 12 Mar 2023 09:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCLIbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 04:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLIbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 04:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29AB4FA9C
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 00:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678609820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTJUAFMiKw9YXPlS9lywYBNgOfv1YiKLGXLNoVp00UQ=;
        b=bgDzcsI60TIDbJ0Y3Gbw4FyR17xVSmXjgOn7F61iA5kI2GlF0OYPWdp0W8IS52oj9r+9vs
        loP7ttvl+B3xfm1kHo4FlByPFOhNVC/A+HFW6Snzv/7+eji/Va+eLRXgcXagOWxCQSPiem
        WiuaaQCrMEUFLhJlL+qECdyPtSAo0uI=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-7mK9F0loNqGNc7dbD3uYCQ-1; Sun, 12 Mar 2023 04:30:18 -0400
X-MC-Unique: 7mK9F0loNqGNc7dbD3uYCQ-1
Received: by mail-ua1-f69.google.com with SMTP id p18-20020ab02a52000000b0073dfce6f0edso2307887uar.16
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 00:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678609818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTJUAFMiKw9YXPlS9lywYBNgOfv1YiKLGXLNoVp00UQ=;
        b=nj8Aeh9lehYInFoEiRwTQJZI2seCozIx9M5un4WXL7m6+FT4/gkNkA0HX0FVaS7SHb
         fOgXsppBozW7K6LwdXVpGleaSd1qjHqJCbYK4cuf2aGOPQbX6xmYrCoHhwr4rMBHxDaR
         29Twsr8zZKtsvfGiHfeHKhtEjtdao+49El6O/fS03PdyxpCsdM/gl46Gv/fiCrnAgI3u
         I6/xZgdGqgV8lzwJpDephGohwHlWnxRAs9FoF+AwCMWq6eHnlZwLNcjY24E2aKvwFkcv
         QoUPKp/o3Cq4A62mwluT23/iV4cqEIpO+b/fyJKatNQ9CiSv0IVrYyhacdxIGiRuRQT3
         CMAw==
X-Gm-Message-State: AO0yUKUPygzU8EynVuNIy3627ci8aFJHzQuGckcdIPpOEMu3tsjOCOg/
        EqIDXUdcIVSu5uJNIg50zxjAK7JBnFYX+YDM9AVh7uLgK9eSoitCz1i49h7hUUTvWdiCoO7qdC7
        xIfh1gyZXbTze2TNaknCSFWTubfWAFUHyV/Y=
X-Received: by 2002:a1f:5081:0:b0:418:4529:a308 with SMTP id e123-20020a1f5081000000b004184529a308mr18819943vkb.3.1678609818161;
        Sun, 12 Mar 2023 00:30:18 -0800 (PST)
X-Google-Smtp-Source: AK7set/XxiUHqj7uZm7+uQmpQQmAFDztF4XwTwbAWzfBXxoaAKYWNuNGHKx1WneKNKQ2hYsmxYfu0s630gn5HA+5VLg=
X-Received: by 2002:a1f:5081:0:b0:418:4529:a308 with SMTP id
 e123-20020a1f5081000000b004184529a308mr18819935vkb.3.1678609817771; Sun, 12
 Mar 2023 00:30:17 -0800 (PST)
MIME-Version: 1.0
References: <Y8lSYBU9q5fjs7jS@T590> <ZAyAdwWdw0I034IZ@pc220518.home.grep.be>
In-Reply-To: <ZAyAdwWdw0I034IZ@pc220518.home.grep.be>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Sun, 12 Mar 2023 16:30:06 +0800
Message-ID: <CAFj5m9KM1xbwPobvEYBmgotrU8s2jBQGcSQafJVJM+iQMS0pjA@mail.gmail.com>
Subject: Re: ublk-nbd: ublk-nbd is avaialbe
To:     Wouter Verhelst <w@uter.be>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 11, 2023 at 9:58=E2=80=AFPM Wouter Verhelst <w@uter.be> wrote:
>
> Hi,
>
> On Thu, Jan 19, 2023 at 10:23:28PM +0800, Ming Lei wrote:
> > The handshake implementation is borrowed from nbd project[2], so
> > basically ublk-nbd just adds new code for implementing transmission
> > phase, and it can be thought as moving linux block nbd driver into
> > userspace.
> [...]
> > Any comments are welcome!
>
> I see you copied nbd-client.c and modified it, but removed all the
> author information from it (including mine).
>
> Please don't do that. nbd-client is not public domain, it is GPLv2,
> which means you need to keep copyright statements around somewhere. You
> can move them into an AUTHORS file or some such if you prefer, but you
> can't just remove them blindly.

Thanks for finding it, and it must be one accident, and I will add the
author info
back soon.

thanks,

