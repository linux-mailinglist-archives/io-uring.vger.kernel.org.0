Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3C42145C1
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 14:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgGDMN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 08:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgGDMN1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 08:13:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72251C061794
        for <io-uring@vger.kernel.org>; Sat,  4 Jul 2020 05:13:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f18so27433803wrs.0
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2020 05:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EtahXPzAi7h8oaK/8L7AsxrF3vCedrc20yu/dp6g3wM=;
        b=tXIZD7mENIpAYkfxLLDMcogPBKR7sM2Sn8l3XEq3Pb4d/SsMhMq9a1ddlqUI+wurtd
         iN/iZiKCKsQFx+W/P00JGJoV4rYEDvcUU5wtK+FbQVwbNEVjGq8UsHd42AYfrkMo0So/
         cBhOdFn0W7MRqhWB5WwUIs3DpSOTzuadq+IO1btMbum+BYWwYfdc7wlB4X3qlfqD03F9
         xmhbFgnDfY1tqOXV7tUw/2dz0Bm9mtznGxBgNcH1mLy+Ghg4ezhpP1m5a6sc0mXnsSM6
         b1fHLJDuopdp35abqAVoQ4a8avU1fhBpeEKfoUTQotLwv2aoeGQg+x1z+KRZ1gHp6TjH
         xM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EtahXPzAi7h8oaK/8L7AsxrF3vCedrc20yu/dp6g3wM=;
        b=HlYzUOidnGXGnG6gCaUc5983wtf9fyL1ufiAu7VUtKl5++YVyqWEmJlM8NgjyCFjP3
         F3OticvNsXVRDFhJEKHmo6hjWZzJEb2JyLl5pDBk4CTfKDPZZyqIsP7Juw8gnVop394M
         cI3/2tqvOPCckuCt9Ru1LJOexYPQREucWsV8oIIEHgIm3uZAPf3E1ouf0vLhEe6Wx5sr
         ul2yQ+arNTG9JIt6Zc/3GvVvXiFlp2EMCkHke+FfPnYIYev5I2ONsnirCLHpAwIqjNP/
         XbVT0DIVX048Kuo14zv4heHd79sdKOx8wAMsk2aAv00a0PF2ETooL0oR0qEEfHJLCc6e
         60bg==
X-Gm-Message-State: AOAM5321ou3NXjrKpHMEXB/LY4a2rCRQba81cKCCHjcgIeKn7XpnOINT
        J0Mc867DgqnV0ecnAHU2cvQCBAJ4+P9mCGWPbt8=
X-Google-Smtp-Source: ABdhPJxDrwnDtuAJeBqivAt15xhvsWNv4lY3herPpK0P3cbV5gCdB2pDkFW4XuZw/taA/VVVdDwEHhMA5yu8HPfCt1k=
X-Received: by 2002:adf:9404:: with SMTP id 4mr39526688wrq.367.1593864805993;
 Sat, 04 Jul 2020 05:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
 <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk> <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
 <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk> <CAKq9yRjBUuTPAp7xuRhZ8X+OugiD0gm6LCbr6ZGzwKyG8hmvkw@mail.gmail.com>
 <e8b0f7e4-066b-4218-9c36-682939a9c461@www.fastmail.com>
In-Reply-To: <e8b0f7e4-066b-4218-9c36-682939a9c461@www.fastmail.com>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Sat, 4 Jul 2020 14:12:59 +0200
Message-ID: <CAKq9yRjwUZ93uybghRTdfjHOMQCs2+FeQ8+fKeWvpeuZi0Ro7w@mail.gmail.com>
Subject: Re: Keep getting the same buffer ID when RECV with IOSQE_BUFFER_SELECT
To:     Hieke de Vries <hdevries@fastmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 4 Jul 2020 at 14:00, Hieke de Vries <hdevries@fastmail.com> wrote:
>
> There was a bug in the echo server code with re-registering the buffer: https://github.com/frevib/io_uring-echo-server/commit/aa6f2a09ca14c6aa17779a22343b9e7d4b3c7994
>
> Please try the latest master branch, maybe it'll help you with your own code as well.
>
> --
> Hielke de Vries

Yes, that fixed my issue too!

Thanks a lot!
Daniele
