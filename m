Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF15C138CAE
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2020 09:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgAMIOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jan 2020 03:14:41 -0500
Received: from mail02.vodafone.es ([217.130.24.81]:30067 "EHLO
        mail02.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgAMIOk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jan 2020 03:14:40 -0500
IronPort-SDR: yXj0HwwMYAm3snri15SMcL8wvYjbwhm9SeXXAo//p4CA1DFnAnZvsj1VDPF+DNowpUZY8UMqY5
 Y1GBhqGA1OdQ==
IronPort-PHdr: =?us-ascii?q?9a23=3A3bpCaxwmN9IVas3XCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd2+IRIJqq85mqBkHD//Il1AaPAdyAraga2qGP6vGocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmTSwbalsIBi3qQjdudQajZZmJ60s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlSELOzkk/m7LkMNwiaJarAu/qhx42Y7UeIaVNOBkcaPBY9wWXH?=
 =?us-ascii?q?ROXsBIWyFdHoO8c5EAAPYBPelGqonyuV0OrQenCQayAuPj0zhGhnjw3aIk0+?=
 =?us-ascii?q?UtCB/J3Ao9FN4KvnnYsMn5OKIUXOuozqfH0C/DYutY1zn98ojGbBMvr+yDUr?=
 =?us-ascii?q?1sfsTc0lUvGgHZgVmMtYDpIy2Z2+IQuGab9epgUuevhnY9pQ5vvjig2N0sgZ?=
 =?us-ascii?q?TJiYISzFDE+jhyzYEtJdKmVE50f8SkEZVXtyGcOIt7WcMiQ3pztykm0LEJpZ?=
 =?us-ascii?q?m7fC0QxJQnxB7ScvqKeJWL7BL7TOudPyp0iXB/dL6iiRu+7VKsxvPzW8Wu3l?=
 =?us-ascii?q?tHrixImcTWuH8XzRzc8M2HR+N4/kemxDmAyRje6vpBIUAojarbLIMhwqIomp?=
 =?us-ascii?q?oTr0vDGij2lV3zjKCMd0Uk/vKo5PrjYrn6qZKQLZF0igbjPas0lMy/BuI4PR?=
 =?us-ascii?q?YUU2eF4uSwzLzj/UvnT7VWlvA6jLTVvZLAKcgGqKO1HxVZ3pgs5hqlATqr0M?=
 =?us-ascii?q?wUnXwdI1JEfBKHgZLpO1bLIP3gFfewnUisnylxx/HIOb3hBJrNI2PDkLf6Zr?=
 =?us-ascii?q?ly91RQxxY0zdBa/Z5UCrIBLOrpWkDtrNzYEgM5MwuszubmD9Vxz54eWXiOAq?=
 =?us-ascii?q?+fP6PfqkGI5u0xLOmWfoMVuyjyK+Ij5/HwiX81g1gdfbOm3chfVHftH/MjPl?=
 =?us-ascii?q?+YZ3XEnNgMCyEJsxA4Qeisj0eNAgRef3KjY6Vp3jwnBZjuMoDFScj5mLGd0T?=
 =?us-ascii?q?2kGZtZZmNGEVqHOXjtfoSAHfwLbXTBDNVml2k8WKSsUcce0heh/FvixqZqNP?=
 =?us-ascii?q?XT/CIwtYnp355+4OiVlRJkpm88NNiUz2zYFjI8pWgPXTJjh/gnrA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HqbQAyJhxeeiMYgtkUBjMYGwEBAQE?=
 =?us-ascii?q?BAQEFAQEBEQEBAwMBAQGBewIBARcBAYEjAgmBTVIgEpNQgU0fg0OLY4EAgx4?=
 =?us-ascii?q?VhggTDIFbDQEBAQEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQBAQI?=
 =?us-ascii?q?QAQEJDQsEK4VKgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKDEABDgFThU8BATO?=
 =?us-ascii?q?FI5cyAYQEiQANDQKFHYI1BAqBCYEaI4E0AgEBjBcagUE/gSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFsgkiCWQSNQhIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4R?=
 =?us-ascii?q?OgX2jN1eBDA16cTMagiYagSBPGA2WSECBFhACT4lXgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2HqbQAyJhxeeiMYgtkUBjMYGwEBAQEBAQEFAQEBEQEBA?=
 =?us-ascii?q?wMBAQGBewIBARcBAYEjAgmBTVIgEpNQgU0fg0OLY4EAgx4VhggTDIFbDQEBA?=
 =?us-ascii?q?QEBGxoCAQGEQE4BF4ESJDoEDQIDDQEBBQEBAQEBBQQBAQIQAQEJDQsEK4VKg?=
 =?us-ascii?q?h0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKDEABDgFThU8BATOFI5cyAYQEiQAND?=
 =?us-ascii?q?QKFHYI1BAqBCYEaI4E0AgEBjBcagUE/gSMhgisIAYIBgn8BEgFsgkiCWQSNQ?=
 =?us-ascii?q?hIhgQeIKZgXgkEEdolMjAKCNwEPiAGEMQMQgkUPgQmIA4ROgX2jN1eBDA16c?=
 =?us-ascii?q?TMagiYagSBPGA2WSECBFhACT4lXgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,428,1571695200"; 
   d="scan'208";a="323927844"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 13 Jan 2020 09:14:38 +0100
Received: (qmail 12196 invoked from network); 12 Jan 2020 03:08:12 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <io-uring@vger.kernel.org>; 12 Jan 2020 03:08:12 -0000
Date:   Sun, 12 Jan 2020 04:08:11 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     io-uring@vger.kernel.org
Message-ID: <26471064.110373.1578798492063.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

