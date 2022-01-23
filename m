Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C530497308
	for <lists+io-uring@lfdr.de>; Sun, 23 Jan 2022 17:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiAWQgZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jan 2022 11:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiAWQgZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jan 2022 11:36:25 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7832C06173B
        for <io-uring@vger.kernel.org>; Sun, 23 Jan 2022 08:36:24 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id y17so336608ilm.1
        for <io-uring@vger.kernel.org>; Sun, 23 Jan 2022 08:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=aOF2iFFKcp/2IbpCOn96WeaJuewVxmYjdjuamHQz7bk=;
        b=pOobaLBgh2TwLqMHcxcaMF/mvDXW9Fxf6FRobJ16IUhF2+Vk2Pj+ortYgiqXyZ0t1c
         QMsUxHlhibvDOkJbUmSTuWmMrMMR0DGttgLeaDj3SQy3Sacmmm21jKHwApIsU4hLnBJr
         lpbxwXXjhuug6Mq9/nohpJh4jjVue/rjRi9GuNFqZ04UysaoABeZLWzqxLCq8sJPWJ2h
         zanftIH3KbeWxmYgbmZdcjEp5DKz+pcMQ1AfQ+P7hAfi6NG2ILwbUhKEySiozdLFxLDm
         0U3L8xHZDchkHeSMiNGJVWE4rIncVQsN2HorqfxYz7LdmXs3rfTnKSWdCHR49WGfqEOc
         umNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=aOF2iFFKcp/2IbpCOn96WeaJuewVxmYjdjuamHQz7bk=;
        b=LRBjwhE6OmjNdYDwrbCQ+I0DF4sB2ZCMlywvwaTTdC7QFi7T3UuedHM45CZTkWxbNz
         1eLHJMyGlSeExrdBCGaKNIls/jagfgN3YNWYma13ikxScC/e4Tp57kGu4DUgoij7lKki
         qgtw/tltgRCa9g/B9b2k1TyykbCnDa0paNXE/5f6v6toOCJWl38iBC7zaCFYy3691j9R
         hM9+TcFS8Fmj8ILynnj3ltknzDNuOF1771q4hSlUZ3JBoCacdLfiIdiIMvMq1hKndcmw
         kld6Z++m4+oDGdOB3/ZDiyLXbs3eiHNoT08WJ06VaaCBuIXe/1PTtYJMrNRBRZAIiKHx
         sptA==
X-Gm-Message-State: AOAM531wtYo+rRnX0Wz3U2/LfxCR2OxQ8GMRgWxLmJ1bw33FR47r9Dlq
        3I7F3txmS0xlYWpQ0G/wr5cKlQ==
X-Google-Smtp-Source: ABdhPJzux7TPSf0w6Q17l4DXEhCS2GVVpnMAts/EqbAJs1Gfi7in2+o9KguP+u11exJF7RfQwMeE2Q==
X-Received: by 2002:a05:6e02:1b82:: with SMTP id h2mr6220432ili.116.1642955784179;
        Sun, 23 Jan 2022 08:36:24 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y6sm6195058ilv.6.2022.01.23.08.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 08:36:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220121123856.3557884-1-dylany@fb.com>
References: <20220121123856.3557884-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: fix bug in slow unregistering of nodes
Message-Id: <164295578348.5567.14720982094932596207.b4-ty@kernel.dk>
Date:   Sun, 23 Jan 2022 09:36:23 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 21 Jan 2022 04:38:56 -0800, Dylan Yudaken wrote:
> In some cases io_rsrc_ref_quiesce will call io_rsrc_node_switch_start,
> and then immediately flush the delayed work queue &ctx->rsrc_put_work.
> 
> However the percpu_ref_put does not immediately destroy the node, it
> will be called asynchronously via RCU. That ends up with
> io_rsrc_node_ref_zero only being called after rsrc_put_work has been
> flushed, and so the process ends up sleeping for 1 second unnecessarily.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix bug in slow unregistering of nodes
      (no commit info)

Best regards,
-- 
Jens Axboe


