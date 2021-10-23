Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164DF43824D
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 10:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhJWIKl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 04:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhJWIKl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 04:10:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48A2C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 01:08:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y7so5715334pfg.8
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 01:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from
         :subject:to:content-transfer-encoding;
        bh=p5gb2q5U030D/tcjiuhdSf78Y1mXbZi5D8OtPUpEGPw=;
        b=JqFMIP91179Sx7IVNs+IuAncG2C6EEXHxX/+UfdOkRvCyJ27pYELhJzGPOa+v/ywAq
         zFhUXbr8eNz6WR5Z+GdFjr8JQDP0hOI/+ysoahiyewpjforsO1nilLRs8VTqJrrRhw6a
         cxJV60I95mOlTp8YUjep9f/F0DLtxMCcKN1EbvyIyA+VD768EUodmjvvkv1HFYVTEBUo
         51P813+eyykcw3OscMwzBoEFAXYa0nNJNCIBb5iISebHnrJYbOwLkbSZOmiY8HzmH9iW
         RgXR34+MeA4+bqS8/+zfkKDoPuN0iuiUaRmm8S62Pr+JaLsT0iAfP0jNKKJPqDgQeF89
         HecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:to:content-transfer-encoding;
        bh=p5gb2q5U030D/tcjiuhdSf78Y1mXbZi5D8OtPUpEGPw=;
        b=vXJuUnUG+dt8uQgIyn5CyFRTUKNhkjwdzJzc5HvtZPFI0o4MDUF6/8erbMhd+xddIV
         GvKlHO3slfZlOo+gjvBj3lhCG6KLU3skYI5IjWNJBR7DX4whZSW0e5nO7ocmkcMFfpro
         vf3JBSIC9xpdTXGPnjJ1FSwBMopvWmcxRZcPQKncS0hHswM5BRw6LEmX96aibJNDVCan
         Mkz3LJ/+Q+ArLXi4ZOh/5voqEyhEBeGiHAVpz0M4G5NJqsXWtZjbAZiBYnKH5ZoUEIab
         IFxlCvadariYvk03MXkDcjRyH74uMLaL6B2w0lE/BKzamNPsHzJE6izOip3kk7CnaQLg
         I7Ag==
X-Gm-Message-State: AOAM532TItp/Fz41n4KgFgIQske1hhNatNsixg8Vdw1ZIV9+um9o1HeU
        O6Rjf7LFUWcVzr3MFsc/cK4pNKpKg4A=
X-Google-Smtp-Source: ABdhPJyn+8+HThdampz5ruCIOSi1xBCqy2trZBeSasqrx5h0j1ZdLKxVOaC0AjSTFAJI3408O7RJXw==
X-Received: by 2002:a62:188c:0:b0:44d:6660:212b with SMTP id 134-20020a62188c000000b0044d6660212bmr4721572pfy.8.1634976501873;
        Sat, 23 Oct 2021 01:08:21 -0700 (PDT)
Received: from [192.168.1.122] ([122.181.48.19])
        by smtp.gmail.com with ESMTPSA id m4sm4249272pjl.11.2021.10.23.01.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Oct 2021 01:08:21 -0700 (PDT)
Message-ID: <e17b443e-621b-80be-03fd-520139bf3bdd@gmail.com>
Date:   Sat, 23 Oct 2021 13:38:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Content-Language: en-US
From:   Praveen Kumar <kpraveen.lkml@gmail.com>
Subject: io-uring
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I am Praveen and have worked on couple of projects in my professional experience, that includes File system driver and TCP stack development.
I came across fs/io_uring.c and was interested to know more in-depth about the same and the use-cases, this solves.
In similar regards, I read https://kernel.dk/io_uring.pdf and going through liburing. I'm interested to add value to this project.

I didn't find any webpage or TODO items, which I can start looking upon. Please guide me and let me know if there are any small items to start with.
Also, is there any irc channel or email group apart from io-uring@vger.kernel.org, where I can post my queries(design specific or others).

Thanks in advance.

Regards,

~Praveen.
