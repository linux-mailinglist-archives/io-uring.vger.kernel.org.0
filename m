Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F821A5F30
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgDLP2q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 11:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgDLP2q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 11:28:46 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2020 11:28:46 EDT
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830ACC0A3BE2
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 08:28:46 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r4so3413361pgg.4
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bPu06Y0LSOzJVH9SSHjwO6Xqedj9DP6ImrFOl58IK6o=;
        b=sDjeeHmMKMX14T+Q+ZNkooX9mpjDyZ7V3J0WrsACW2Mol85wmERgGfHoHBz33GCiAF
         PQ04FF7yrMB/kyrtuplYCxGwh9cQHgwT1I7YMkU03j/06zxxxtoHxMlUqyNfXY4ZgYiG
         tehOj+QRs8EIYlDw190lZuhmME9wsWydfPxPcrBl7YAgjbe0wFy3I4RWQYjgdA/sbKbU
         j/+gcjsxavPeC8RuwplbOa9W1IrENmoe7cWwrGpeZxjlAp9bZsjshUDDKGrfX3KXsXdM
         6fO/npp0g+BCynx5xx+cc9knYbPh+yl0QIxneMsqd6NkGwVzlM8TFjrdb/wB1hAJgK2p
         S5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bPu06Y0LSOzJVH9SSHjwO6Xqedj9DP6ImrFOl58IK6o=;
        b=a+BbSpRlUPvw39+kXm0EoL7Hhm2TqqDS8YPjnzOyLJBuk9aobXnDzr3gXEu/XpHkhh
         u76vlRbrVJL0mQoSKkC7ee+tgSC/vexc8kv3aMwJ0jJXzkMeyTvbj5slEQhkbtFCp93X
         tu/FQsOgWy7YLPYrW9BLUZm9Wb6zv1q5ar8YEX7cGk2Yj+qUuUjmrPg2dDf24RkCOgY4
         FYqKjTJpKgFtGVOFyr3m9iCuhtbvDQ1KqpTZYG8+PGQFQhVqHFdOKJorFjhZSbiJvUkn
         Ars7QKwfJYsbaiaTW3O0L+dTXH5enyuOvryXo6QpuLrqtwcfkdUUZgU6CmAasG5UHPyW
         U1Sw==
X-Gm-Message-State: AGi0PuYcuUop2IFPCTY3XufAOUOOCqAmzi9hUN2IWNYof6Hv4coyH+Y7
        u/18ohv7zTrmAMMK4RpavCqo7/iUco5oFg==
X-Google-Smtp-Source: APiQypJuHkJQ/eZQ0ctywlQEVWlat844ih2p/RpH3Qn7wAA9ppIOrqK0tyBRsd9xlh2OiD1xsYPlww==
X-Received: by 2002:a62:18c8:: with SMTP id 191mr6749503pfy.255.1586705325640;
        Sun, 12 Apr 2020 08:28:45 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id h193sm928637pfe.30.2020.04.12.08.28.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 08:28:45 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: Upcoming liburing-0.6 release
Message-ID: <2ec49990-639a-f6ac-15ca-7ac26d2d9769@kernel.dk>
Date:   Sun, 12 Apr 2020 09:28:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I want to release 0.6 this week. Just a heads up if you've been holding
back on a patch or two, so the release doesn't catch anyone by surprise.

-- 
Jens Axboe

