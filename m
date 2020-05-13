Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4FD1D106C
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 13:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgEMLCH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 07:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgEMLCH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 07:02:07 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C1C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 04:02:05 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i5so610094qkl.12
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 04:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYbuSTSEXUMSooc/O6v+uLXRdzjLHkh9w8KM+rnHyB8=;
        b=uFPzRODqgYmWbwxYLP+M63msAXn2yIblPX4tl5Y+e6XLV0CrIjR68SD0fenlxpkf6u
         TD9shU8KcHdRBjOQm1pp0M5eSYWmbRQ/Dma4+JLDOyYyVEjX5M63mP6AsodsBh8V1FZK
         AmPCdoQ4WsDdoRLJ7h65PKxfK6Lg1KazNQ9Em+ZmX+b4FW32p5afxZnSCAENo07NHPP+
         p6GgzZgzm+z5QsvmjUQL9Fh4P86paoMlR+wQ3AKuZfuu66bU2kBfnR9pVtnMT2Ysx2Ov
         0fIwYKp88FiAaSScH132cRk46kPRrY7TSPEXi1GPuQRmwrcj+Ty8ysdvwZ5S7aLacgl4
         +f5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYbuSTSEXUMSooc/O6v+uLXRdzjLHkh9w8KM+rnHyB8=;
        b=K3U9+QYn9MHS3upMqG3eiO7LhmGMhkNzNKXD+NpigXpZ4/IB3zX5XgLU+jnTgpBqOJ
         njBMBfUtLTSn/ho2tOkaD+tspRKiBb3J685PFphXk0yk0KRZP0HiyjP0usMJC76KAOnD
         zT9+/5woD93Q42eZnc1fAdsmiT78pnBOl/nUQi5Uhjbi378/FhOxl7EVZwrxZMFzRu6M
         t023XZiSh+n/Q9Q8jvuTpp9PrwaA8KQTe5WhQmZAvmLUgOA7iu8vv+pKVctzjkpihe+x
         YchGplDMqirH/QskQSsSJ+mHGvynsZzLkd7yprHD9H8EWL1jdRTlzx49mLKcrpD1kWuR
         RwSw==
X-Gm-Message-State: AGi0PubraVopWRvl+2FlT8F+zRS4oBgyq6vQZHORc8WnkT93zwdkfbKW
        1PDzX0C7QDysLuqoAC3Y4cd37s1yXkTfeW7dcEQ/tjUZvTS37Jc=
X-Google-Smtp-Source: APiQypK33cRoEFwlfd7QOqGPMc35osvD4pXD2iX/OmqeeyICrjudkr9/iFXYGptn2Q32dUvcRU15nIOMmkjBRW0VDPs=
X-Received: by 2002:a37:a485:: with SMTP id n127mr13566595qke.476.1589367723508;
 Wed, 13 May 2020 04:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com>
In-Reply-To: <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 14:01:28 +0300
Message-ID: <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     "H. de Vries" <hdevries@fastmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Hielke,

> If you want max performance, what you generally will see in non-blocking servers is one event loop per core/thread.
> This means one ring per core/thread. Of course there is no simple answer to this.
> See how thread-based servers work vs non-blocking servers. E.g. Apache vs Nginx or Tomcat vs Netty.

I think a lot depends on the internal uring implementation. To what
degree the kernel is able to handle multiple urings independently,
without much congestion points(like updates of the same memory
locations from multiple threads), thus taking advantage of one ring
per CPU core.

For example, if the tasks from multiple rings are later combined into
single input kernel queue (effectively forming a congestion point) I
see
no reason to use exclusive ring per core in user space.

[BTW in Windows IOCP is always one input+output queue for all(active) threads].

Also we could pop out multiple completion events from a single CQ at
once to spread the handling to cores-bound threads .

I thought about one uring per core at first, but now I'am not sure -
maybe the kernel devs have something to add to the discussion?

P.S. uring is the main reason I'am switching from windows to linux dev
for client-sever app so I want to extract the max performance possible
out of this new exciting uring stuff. :)

Thanks, Dmitry
