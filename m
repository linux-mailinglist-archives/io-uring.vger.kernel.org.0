Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60433A4C7D
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 05:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFLDoK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Jun 2021 23:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLDoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Jun 2021 23:44:09 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD4AC061574
        for <io-uring@vger.kernel.org>; Fri, 11 Jun 2021 20:41:54 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f10so18823313iok.6
        for <io-uring@vger.kernel.org>; Fri, 11 Jun 2021 20:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=dq+wZSrr2OWJDtqHTLZdT1GMNxpqU2xq4fBlOqz4Nu81ZM5ZBKIH4N+qDCcB+QoAAS
         fAvWAhgYlmWMqvmNvVmS2COQZA1zhkeKQ1NDJa9NL1xBBQzM9TozD6jzU30XmQmDwbey
         v+o3I+3EzyZIV3pRRDtbp2BcFDjUFi5ToRcf572noDR6P2I4jAKSBbLMX8V7ClA9yvge
         K3NIbyLUMCOZtQ1edOpoylgB6TllPBQqlxCwGp8dNsXfcxjZP5W5A0oqig+ePU970/ph
         Bw3qyXdhi/EkNRdpVVWtYr2FqBsWjRE8USGpJkScjNWRL3+B8Jv3vAHk8or87Igw/gnf
         BAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=q0EHulsSnUHBs52jpYh5Oisa9zIQCGPykkWj9Qh8BDaSs3ImPNKESuDvvZHytZkf5h
         1fLPlkCPwQ6t/8tUVkJloHxmsJyiTfuknN51XFb9KOOn3KM8EWNltxhFWtQnp30chjWt
         CajtzKwhYcIrLrJKGOHFQBRl5ZopYglN1jOBd8fMP3BmV0mKyYIGrK1kjCIe5PYOvVgj
         SLtlhoizV+94sho6gyOX2W2ZbsjGGQqm+0utPecsRX52iR/je0T8TJDdGax61FM69iXV
         dbYLNjUde+UrNEMB5ed1Nu4QZf4EOhep5Bm5eP2eYJY4vv3HN0KvytPM3bOxKpkuRiqG
         YQHQ==
X-Gm-Message-State: AOAM530RFWjL9msR089NelqUmXMKzDqn8xwjLdONJVq50tNzjC5Bvaht
        ilMr06nJfzXkazym3J48KY3qQmmyU/VQFC7FdEhAapBhgHD8fA==
X-Google-Smtp-Source: ABdhPJx4uItVZnAN9LEU09lLVxW/f+vsGIltyKTpPtHXIRgM03uyHo6/StX2xJd2ks5qk4uaGYgTwjJy2EM69va0jTo=
X-Received: by 2002:a05:6638:3471:: with SMTP id q49mr6727995jav.23.1623469313679;
 Fri, 11 Jun 2021 20:41:53 -0700 (PDT)
MIME-Version: 1.0
From:   Ammar Faizi <ammarfaizi2@gmail.com>
Date:   Sat, 12 Jun 2021 10:41:27 +0700
Message-ID: <CAFBCWQJX4Xy8Sot7en5JBTuKrzy=_6xFkc+QgOxJEC7G6x+jzg@mail.gmail.com>
Subject: 
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

subscribe
