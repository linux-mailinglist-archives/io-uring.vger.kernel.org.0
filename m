Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA08F258E9C
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 14:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIAMvm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 08:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgIAMv2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 08:51:28 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A01C061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 05:51:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d26so1485604ejr.1
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 05:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5D0DRHC77+7WNhEw1MYVGlV3EIVchTC9NoLnc0ApgJ8=;
        b=gvlVD8nugqDSMrIpHLDUwWCu4fYqeF7UdnGRanvl+PXJStxIKcRWNXq8zwKI2yW4bN
         x7+H+/HRoPjdfmnRLSnuJgvJEpoVaQ4N72piHVmMNWy+F976z5kWGgB3kt4IoIPUQn3p
         f8YXfSnw2q4bcC+k5HYLfDjsnbzotmwENfrKEN9G5J6B8/S9ABonpHp75VhVi5PAelIp
         TVrkY75LWL5KdNsOTPGcH72ru0OEOMUUHaLq5cHphHKq3H9EZLuLM+r9so/lCwqfKJEN
         JQ94qv+HaitaM3Tdn+NgA1YHC7o6wyTYuZrVXlgzijZCph0CQk3FW61yOPXCaXuKHVK8
         hTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5D0DRHC77+7WNhEw1MYVGlV3EIVchTC9NoLnc0ApgJ8=;
        b=hrcn8WR4V7cenUY0PUGgA9UcSJGmhAOF22h/e/sQIsQZLZG5q1DDj20DlRdCh6irdX
         1VCyWUkqXFh6TxtSURdagmaB0T7fH9jN0bZI3cvSWyNc8J/Nv8fxavudOeT81Rs8Vb5D
         CXaMwTaD8sjjJu0a4HbP+jz3s5eoIeeahOUeYBVxCUFi6oOPBYLhJz6IteZpYnLrYpCi
         tJt0sPBiXZANNFFGF5kY9v4lDUScA/TFlAuVhAsRQhhX8e7c25YOApo010EXHli09td3
         e/wXFO577PACby38+nPe0CSDgFmQUNZA1olcZhArUjtIpwfyhj2xRUmydkWGkP7f9hDr
         oMrg==
X-Gm-Message-State: AOAM532fH0TKv+2Bt/UoCMWe4pokbuhCt024WqZd5Crbn5sjLbcYw0jv
        6BeafYcWdN5CTSN9SF+QqG+2rZBqmGwg+IzCN2tVGYUo3H8d9g==
X-Google-Smtp-Source: ABdhPJzL6Qm5f09vIFrOpNPb4F2ISa8H4OkgDXhTxG7JbPTZVpUanB+3L1+d97EDH9v4tXTqTX+UuUTJo5fna9sGyGo=
X-Received: by 2002:a17:906:9353:: with SMTP id p19mr1275027ejw.403.1598964681872;
 Tue, 01 Sep 2020 05:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAF=AFaLzf=B28CXt0qJ0z7wXfRosqLPYQYtC-DrVogA0J_5AKw@mail.gmail.com>
 <81700e99-21cb-c338-f1f7-8019b2cb6928@kernel.dk>
In-Reply-To: <81700e99-21cb-c338-f1f7-8019b2cb6928@kernel.dk>
From:   Shuveb Hussain <shuveb@gmail.com>
Date:   Tue, 1 Sep 2020 18:21:10 +0530
Message-ID: <CAF=AFaLxuUutwB94JXdRuCf0vWHNUPNeX71Pk8VpHpKML5PntQ@mail.gmail.com>
Subject: Re: Unclear documentation about IORING_OP_READ
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

> This is intended behavior, you should consider the READV to be just
> like preadv2() in that it takes the offset/iov/flags, and ditto on
> the write side. READ is basically what a pread2 would be, if it
> existed.
>
> That said, you can use off == -1 if IORING_FEAT_RW_CUR_POS is set
> in the feature flags upon ring creation, and that'll use (and updated)
> the current file offset. This works for any non-stream/pipe file
> type.
>

That clarifies it. Thanks, Jens.

-- 
Shuveb Hussain
