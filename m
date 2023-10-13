Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4297C8A7E
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjJMQF3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 12:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjJMQFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 12:05:25 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFF2195
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 09:05:12 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-d857c8a1d50so2260677276.3
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 09:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1697213111; x=1697817911; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJIUpMJ5wACe5qVMzOsP9GUn7pUpbtvNyTj02yy63pw=;
        b=CgWHbEBf4CeGZwSS+Iwwm7byS3IDHNWp24uKKZbOOQe7dvaAXNdUmD2AJS0AlaY6sf
         d0dNs2V8Yx4bft/zp19dYJpFSOCybDGaO0SxkkkHbHggJitkqpdvjzzc/zxDC1VutWWo
         eBrQBRYfYzbB3gn5kZiKQ+7IG2xTbLmOqF4qeuiy5Kj9MD9bVqQm85nL5hoPoCEuDVMw
         fjmE5kscePYUzzT9NpAO3YQT2KxY9ct7Lvi6C1pYu+Ox85r7gYrZ7LwGpVt00JOjJLqo
         w4s7HGy/IeKKkaYgQkPVJ267XujjkI8KpkoFnhcLOwjZ5yI+UZAMpMvB5E8mh9KykRAG
         VevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697213111; x=1697817911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJIUpMJ5wACe5qVMzOsP9GUn7pUpbtvNyTj02yy63pw=;
        b=MItjD8dFBX5W0FlIZ68SnagNREV7o+wiwPxI1knORGRspdnxus54EzENsno4xNMhtg
         qZzQ6QHLaUYhZJaU8MHQbH77L+ZjfJtIqcUppOCCbo6GPLJiiMz90YDSQ1gmN5FgUiPD
         b30q52qhbReqLDVJDQEXW7JM0vS8KptU7VGtryr0EzSlw6IFkjOCmRr0iDlpGpZoN4jU
         xd/4jSBUTWWM1JG0lVY+bqtYej8PzWp72DKuzzUxZ90NWnpnpRfTnqUMWiXZOhMWz5zW
         SCeAAmsD18OSUDdlyNzonWKr4DoK7YLJfQKZqWICOVs3sjOfBj4CPpy4Xm/33p+VjAr2
         YPhw==
X-Gm-Message-State: AOJu0Yy/C7cve/3SAjy4eVIxa4n5Jz65M4Zrsm0uausfS+cLB89fCCAx
        TcopAEoVvI7gEESGbeF/mJSauzw3NhXu69OaEOet
X-Google-Smtp-Source: AGHT+IHpOSANOrQKBQgtUgStfgXLEaTDhiwuX8RmP+7vz4a8DNxO1ohlNmWN6m1GXQ9c27fFcBbMW4NNTEH1Lhj5YvE=
X-Received: by 2002:a25:4e05:0:b0:d69:8faa:5a28 with SMTP id
 c5-20020a254e05000000b00d698faa5a28mr24864064ybb.55.1697213111288; Fri, 13
 Oct 2023 09:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-karierte-mehrzahl-6a938035609e@brauner> <CAHC9VhTQFyyE59A3WG3Z0xkP6m31h1M0bvS=yihE7ukpUiDMug@mail.gmail.com>
 <55620008-1d90-4312-921e-cef348bc7b85@kernel.dk>
In-Reply-To: <55620008-1d90-4312-921e-cef348bc7b85@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Oct 2023 12:05:00 -0400
Message-ID: <CAHC9VhTb6T6fiVTQTBKP6t-zQnDtSck1TuBbETBjs4bt=ryh=Q@mail.gmail.com>
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dan Clash <daclash@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.clash@microsoft.com, audit@vger.kernel.org,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 13, 2023 at 12:00=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 10/13/23 9:56 AM, Paul Moore wrote:
> > * You didn't mention if you've marked this for stable or if you're
> > going to send this up to Linus now or wait for the merge window.  At a
> > minimum this should be marked for stable, and I believe it should also
> > be sent up to Linus prior to the v6.6 release; I'm guessing that is
> > what you're planning to do, but you didn't mention it here.
>
> The patch already has a stable tag and the commit it fixes, can't
> imagine anyone would strip those...

I've had that done in the past with patches, although admittedly not
with VFS related patches and not by Christian.  I just wanted to make
sure since it wasn't clear from the (automated?) merge response.

> But yes, as per my email, just
> wanting to make sure this is going to 6.6 and not queued for 6.7.

Agreed.

--=20
paul-moore.com
