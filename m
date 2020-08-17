Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7612465D6
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHQL63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 07:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgHQL61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 07:58:27 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD9CC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 04:58:25 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 62so14642904qkj.7
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 04:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yMPl8OYQUi5q1DcLZkqWCzRwestiSj0tjM+8zCUG7S8=;
        b=qyP+3tbz3uf+f92Kd0yp5GeQe3BremONkUoDKW0KaVorUsPaeWqeUGFnrPXQKNkaGC
         ks6gVc43olt54MEfr9LuKmzLpmMAmzsT/TDINstiILozax9D0MXTgS/w63HJl6Drr3AL
         n9yEnOcnFtROiWFXZTbeyJ+oCP71qczUQ6XU1c0N/OUPPIn6/4/FyuesxffkvOx9BCoJ
         Ty9akFbvxxgdw497lkwvaRS69Vlg+P399xKLxS/CmEeUSRznKSC1/I2Jbkgvl/0W+HV0
         COodiELaLIo5HRWR7HsS1xFzOAP2JDhxG7WVwmqfcH4JHtNyTSrgMmu0tXFXhGbUREFc
         yyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yMPl8OYQUi5q1DcLZkqWCzRwestiSj0tjM+8zCUG7S8=;
        b=ovQ3WK3M3sg+a+usUo2Zb3owi2VeV2tTQJKBHu7VU9VMMqUDiHM/o62wMr4H1GenDn
         QrlDJlM/+W4V/HqdEa6mtj/ZqnqFqcko6aPo03c30BALeIqDwmaISzQ3gEQmuYJi0ibQ
         Uk4eG7GEUlyg/A7ipdoRhXbGZ4vV0kZ6IX6JixTqoG3c74+X/nrI2PtAZyFYhNisZWQ2
         tVdTMGz2DghMKDNQxP+n4EKM3wno1iCK+7GsL9Ri+H2/OEeFxJv4T4+LnkMGvMZJwF8W
         B3IsWz1Qk6R2BGmKgG0lKTaJttk8d502oL/khGhahurDl8eUPVtQOoAvg+J7C4lS2Xhm
         BrsQ==
X-Gm-Message-State: AOAM532NMbp94MhzQ7qjY/VYUrq0bXEi+aO2K0Y8NRw+CRRM7XqwND3B
        4KG8m62snMsRElXYsfwD5qne6+3NXB/mscCNiQdQHGIp
X-Google-Smtp-Source: ABdhPJwrkG1DjNMwBNBya9Cu+A18+5HFZYKDPepPBHsZyVO2Ljr1bnbidDg7ZV7+FsngBzuCC2poZ9/hDxlsvoPjcEM=
X-Received: by 2002:a37:6653:: with SMTP id a80mr11995811qkc.499.1597665503493;
 Mon, 17 Aug 2020 04:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
In-Reply-To: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 17 Aug 2020 14:58:12 +0300
Message-ID: <CAF-ewDq24YTjjH2E52dMU3+NZn2dc8O0cEQm=zSLN7Zbc17uLQ@mail.gmail.com>
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Forgot to mention, that this is on 5.7.12, with writev/read during operations.

On Mon, 17 Aug 2020 at 14:46, Dmitry Shulyak <yashulyak@gmail.com> wrote:
>
> Hi everyone,
>
> I noticed in iotop that all writes are executed by the same thread
> (io_wqe_worker-0). This is a significant problem if I am using files
> with mentioned flags. Not the case with reads, requests are
> multiplexed over many threads (note the different name
> io_wqe_worker-1). The problem is not specific to O_SYNC, in the
> general case I can get higher throughput with thread pool and regular
> system calls, but specifically with O_SYNC the throughput is the same
> as if I were using a single thread for writing.
>
> The setup is always the same, ring per thread with shared workers pool
> (IORING_SETUP_ATTACH_WQ), and high submission rate. Also, it is
> possible to get around this performance issue by using separate worker
> pools, but then I have to load balance workload between many rings for
> perf gains.
>
> I thought that it may have something to do with the IOSQE_ASYNC flag,
> but setting it had no effect.
>
> Is it expected behavior? Are there any other solutions, except
> creating many rings with isolated worker pools?
