Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68498349088
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 12:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhCYLfj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 07:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231340AbhCYLd3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 07:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616672008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=WzowP+sLkDfedW5lZC+DZjAa2iepM0HqhQ8ixqDL3Ws=;
        b=NHpsNXcXwwkkDMC88GAr7Rb1LmpCS2dwscpNkqiCPix4kuRaCLFk+bFRWzom5NH83d+4U3
        Kr3OHUWKjfGaWFYZqfwVpwfMLwSRwWMur/DTLH+ToFa7hE4MEL/itEzL0ddWpfhcI7wNhU
        01MfI/nBqEmyGQ3EBw4OAY86TB9ZSEM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-kV-li-nsMCWlFuL8A5bj4g-1; Thu, 25 Mar 2021 07:33:26 -0400
X-MC-Unique: kV-li-nsMCWlFuL8A5bj4g-1
Received: by mail-wm1-f71.google.com with SMTP id r65-20020a1c2b440000b029010f4ee06223so842385wmr.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 04:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WzowP+sLkDfedW5lZC+DZjAa2iepM0HqhQ8ixqDL3Ws=;
        b=TW8kikKJ/63+ffbNWRaaKOdJrH0wTgglHVYY7AHd9Oo+GFngTotODAm+eiOuwetmdk
         RTmwjkoNnYU/V21Omy1YAkyB7UdEdGHCYLQAKSrMpVElULh+kjbdEwJBMRUhgyinso6w
         0II7nKKDr8H7Muvml1tid2+nRCyWhKM9fB5r/S35EK1iUcWFmdZVUMzL5HgxbS34pDgx
         TEdTa6RqsDapuO+u59q20BZj8r2fmols4GeGGX9RhbpX+a+RWes6vUy4GPoCdkWXdyDP
         n0APow0HpVAn5YaD9Ber1OondCPqM9wngo8ERvDYN0ZI7O4gg3SOl5fO90IOs7S/KO+G
         hlbw==
X-Gm-Message-State: AOAM532BFVGuKd6qtLmUWlHlZ3ktS8GXnoCQh+CwIqQACbWuRiV8IDNy
        kdH/pKCypiB0spjczVzSbrYIa809Mak9LeahyfuP78pkxe24qxfNHNBqgcdg1rEy6bQovJ2pNvW
        IqIt02LrvOIqe7AlqwUI=
X-Received: by 2002:a05:600c:4f89:: with SMTP id n9mr7614718wmq.133.1616672005209;
        Thu, 25 Mar 2021 04:33:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeb+RXeOXpc4pbgT9ly41sA9xcWuuvPd6YRWfU5Ap/hhUSDfGV3R125XtSc3HB9Ye+rOnpVQ==
X-Received: by 2002:a05:600c:4f89:: with SMTP id n9mr7614700wmq.133.1616672005034;
        Thu, 25 Mar 2021 04:33:25 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id 1sm11022599wmj.0.2021.03.25.04.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 04:33:24 -0700 (PDT)
Date:   Thu, 25 Mar 2021 12:33:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Are CAP_SYS_ADMIN and CAP_SYS_NICE still needed for SQPOLL?
Message-ID: <20210325113322.ecnji3xejozqdpwt@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, Hi Pavel,
I was taking a look at the new SQPOLL handling with io_thread instead of 
kthread. Great job! Really nice feature that maybe can be reused also in 
other scenarios (e.g. vhost).

Regarding SQPOLL, IIUC these new threads are much closer to user 
threads, so is there still a need to require CAP_SYS_ADMIN and 
CAP_SYS_NICE to enable SQPOLL?

Thanks,
Stefano

